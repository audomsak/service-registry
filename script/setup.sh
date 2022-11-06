#!/bin/sh

project=service-registry

#===================================================================================================================================
# Functions
#===================================================================================================================================

install_operator()
{
    operatorNameParam=$1
    operatorDescParam=$2
    ymlFilePathParam=$3

    echo
    echo "Installing $operatorDescParam..."
    echo

    oc apply -f $ymlFilePathParam -n $project

    echo
    echo "Waiting for $operatorDescParam to be available..."
    echo

    available="False"

    while [[ $available != "True" ]]; do
        sleep 5
        available=$(oc get -n $project operators.operators.coreos.com \
        $operatorNameParam.$project \
        -o jsonpath='{.status.components.refs[?(@.apiVersion=="apps/v1")].conditions[?(@.type=="Available")].status}')
    done

    echo "$operatorDescParam is now available!"
}

#===================================================================================================================================
# Entry Point
#===================================================================================================================================

#=======================================
# Create a project and install operators
#=======================================

echo
echo "Creating $project project..."
echo

oc new-project $project --display-name="Red Hat Integration Service Registry" --description="Red Hat Integration Service Registry"

echo
echo "------------------------------------------------------------------------------------------------------------------------------"
echo
echo "Installing OperatorGroup..."
echo

sed "s/CHANGE_ME/$project/g" ../manifest/operator-group.yml | oc apply -f- -n $project

echo
echo "------------------------------------------------------------------------------------------------------------------------------"

operatorName=crunchy-postgres-operator
operatorDesc="Crunchy Postgres for Kubernetes Operator"
ymlFilePath=../manifest/crunchy-postgres-subscription.yml

install_operator $operatorName "$operatorDesc" $ymlFilePath

echo
echo "------------------------------------------------------------------------------------------------------------------------------"

operatorName=service-registry-operator
operatorDesc="Red Hat Integration - Service Registry Operator"
ymlFilePath=../manifest/service-registry-subscription.yml

install_operator $operatorName "$operatorDesc" $ymlFilePath

echo
echo "------------------------------------------------------------------------------------------------------------------------------"

operatorName=rhsso-operator
operatorDesc="Red Hat Single Sign-On Operator"
ymlFilePath=../manifest/sso-subscription.yml

install_operator $operatorName "$operatorDesc" $ymlFilePath

echo
echo "------------------------------------------------------------------------------------------------------------------------------"

#=======================================
# Deploy Crunchy PostgreSQL Database
#=======================================
application="Crunchy PostgreSQL database"

echo
echo "Deploying $application..."
echo

oc apply -f ../manifest/postgres.yml
# oc apply -f ../manifest/postgres-ha.yml


echo "Wait for $application to be available..."
echo

readyReplica=0
while [[ $readyReplica == 0 ]]; do
    sleep 1
    readyReplica=$(oc get postgrescluster.postgres-operator.crunchydata.com postgres \
    -o jsonpath='{.status.instances[?(@.name=="instance1")].readyReplicas}' -n $project)
done

echo "$application is now available!"
echo
echo "------------------------------------------------------------------------------------------------------------------------------"

#=======================================
# Deploy Service Registry
#=======================================
application="Red Hat Integration - Service Registry"

echo
echo "Deploying $application..."
echo

sed -e 's/DB_USERNAME/$pgUsername/g' \
    -e 's/DB_PASSWORD/$pgPassword/g' \
    -e 's/JDBC_URL/$jdbcUrl/g' \
    ../manifest/apicurio.yml \
     > sr-yaml.template

pgUsername=$(oc get secret postgres-pguser-service-registry -n $project --template='{{index .data "user"}}' | base64 -d) \
pgPassword=$(oc get secret postgres-pguser-service-registry -n $project --template='{{index .data "password"}}' | base64 -d) \
jdbcUrl=$(oc get secret postgres-pguser-service-registry -n $project --template='{{index .data "jdbc-uri"}}' | base64 -d) \
envsubst < sr-yaml.template \
| oc apply -f- -n $project

rm sr-yaml.template

echo "Wait for $application to be available..."
echo

oc wait --timeout=300s --for condition=ready apicurioregistries.registry.apicur.io service-registry -n $project

echo "$application is now available!"
echo
echo "------------------------------------------------------------------------------------------------------------------------------"

#=======================================
# Securing Service Registry with SSO
#=======================================
echo
echo "Securing Service Registry with Red Hat Single Sign-On..."
echo

domain=$(oc whoami --show-console|awk -F'apps.' '{print $2}')

echo "Create HTTPS route for Service Registry..."
sed "s/CLUSTER_DOMAIN/$domain/g" ../manifest/service-registry-route.yaml | oc apply -f- -n $project

# Deploy Single Sign-On
application="Red Hat Single Sign-On"

echo
echo "Patching $application Subscription to use $application 7.5 container image..."

patch='{"spec":{"config":{"env":[{"name":"RELATED_IMAGE_RHSSO","value":"registry.redhat.io/rh-sso-7/sso75-openshift-rhel8:7.5"}]}}}'
oc patch --type=merge subscriptions.operators.coreos.com rhsso-operator -p $patch -n $project

echo
echo "Deploying $application..."
echo

oc apply -f ../manifest/keycloak-internal-db.yaml -n $project

echo "Wait for $application to be available..."
echo

ready=false
while [[ $ready != "true" ]]; do
    sleep 5
    ready=$(oc get keycloaks.keycloak.org keycloak -o jsonpath='{.status.ready}' -n $project)
done

echo "$application is now available!"
echo
echo "------------------------------------------------------------------------------------------------------------------------------"

keycloakUrl=$(oc get keycloaks.keycloak.org keycloak \
    -o jsonpath='{.status.externalURL}' -n $project)

#keycloakUrl="https://"$(oc get route keycloak -o jsonpath='{.spec.host}' -n $project)
#-----------------------------------------------------------

# Create Keycloak Realm
echo
echo "Creating Keycloak Realm for Service Registry..."
echo

sed 's/SERVICE_REGISTRY_URL/$serviceRegistryRoute/g' ../manifest/keycloak-realm.yaml > realm-yml.template

serviceRegistryRoute=https://service-registry.apps.$domain \
envsubst < realm-yml.template \
| oc apply -f- -n $project

rm realm-yml.template

echo
echo "A Keycloak Realm is created."
echo
echo "------------------------------------------------------------------------------------------------------------------------------"

#-----------------------------------------------------------

#Patch Service Registry
echo
echo "Updating Service Registry configuration..."
echo

patch='{"spec":{"configuration":{"security":{"keycloak":{"url":"'$keycloakUrl/auth'","realm":"registry","apiClientId":"registry-client-api","uiClientId":"registry-client-ui"}}}}}'
oc patch --type=merge apicurioregistries.registry.apicur.io service-registry -p $patch -n $project

echo
echo "Service Registry configuration is updated."
echo
echo "------------------------------------------------------------------------------------------------------------------------------"
echo
#-----------------------------------------------------------

keycloakAdminUser=$(oc -n $project get secret credential-keycloak --template={{.data.ADMIN_USERNAME}} | base64 -d)
keycloakAdminPassword=$(oc -n $project get secret credential-keycloak --template={{.data.ADMIN_PASSWORD}} | base64 -d)
serviceRegistryUrl="https://"$(oc get route service-registry -o jsonpath='{.spec.host}' -n $project)

echo
echo "=============================================================================================================================="
echo "URLs and credentials"
echo "=============================================================================================================================="
echo "Service Registy URL: $serviceRegistryUrl"
echo "Admin Username: registry-admin"
echo "Admin Password: changeme"
echo
echo "SSO Web Console URL: $keycloakUrl"
echo "Admin Username: ${keycloakAdminUser}"
echo "Admin Password: ${keycloakAdminPassword}"
echo "=============================================================================================================================="
echo
echo "Finished!!"
echo
