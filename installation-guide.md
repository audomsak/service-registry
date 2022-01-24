# Red Hat® Integration - Service Registry installation guide

Red Hat® Integration - Service Registry is a service that provides an API and schema registry for applications i.e. microservices. Service Registry makes it easy for development teams to publish, discover, and reuse APIs and schemas.

Well-defined API and schema definitions are essential to delivering robust microservice and event streaming architectures. Development teams can use a registry to manage these artifacts in various formats, including OpenAPI, AsyncAPI, Apache Avro, Protocol Buffers, and more. Data producers and consumers can then use the artifacts to validate and serialize or deserialize data.

This installation guide will show you how to install Red Hat® Integration - Service Registry on [Red Hat® OpenShift Container Platform](https://www.redhat.com/en/technologies/cloud-computing/openshift/container-platform) 4.8 and use PostgreSQL as a storage for the Service Registry. Though, [Red Hat® AMQ Streams](https://www.redhat.com/en/resources/amq-streams-datasheet) can also be used as a storage as well. See an offcial [Installing and Deploying Service Registry on OpenShift](https://access.redhat.com/documentation/en-us/red_hat_integration/2021.q3/html/installing_and_deploying_service_registry_on_openshift/index) document for more details.

- [Red Hat® Integration - Service Registry installation guide](#red-hat-integration---service-registry-installation-guide)
  - [Setting up a project](#setting-up-a-project)
  - [PostgreSQL database deployment](#postgresql-database-deployment)
    - [Installing Crunchy Postgres for Kubernetes operator from the OpenShift OperatorHub](#installing-crunchy-postgres-for-kubernetes-operator-from-the-openshift-operatorhub)
    - [Deploying PostgreSQL database](#deploying-postgresql-database)
  - [Red Hat Integration - Service Registry deployment](#red-hat-integration---service-registry-deployment)
    - [Installing Service Registry from the OpenShift OperatorHub](#installing-service-registry-from-the-openshift-operatorhub)
    - [Configuring Service Registry with PostgreSQL database storage](#configuring-service-registry-with-postgresql-database-storage)
  - [Testing Service Registry via REST API](#testing-service-registry-via-rest-api)
    - [API testing using Postman](#api-testing-using-postman)
    - [Performance testing using hey](#performance-testing-using-hey)

## Setting up a project

1. Log in to OpenShift web console using an account with cluster administrator privileges.

2. Go to **Projects** menu, then click on **Create Project** button.

   ![Project Setup](images/project-setup-1.png)

3. Enter a project name, then click on **Create** button.

   ![Project Setup](images/project-setup-2.png)

## PostgreSQL database deployment

We're going to use PostgreSQL database as a storage for Service Registry so we need to setup the database first and make sure it's ready to use. There are plenty of options for PostgreSQL operators or containers that can be installed on OpenShift. You can use either commercial or community version that suites your environment and requirement. This guide will show you how to deploy PostgreSQL database using [Crunchy Postgres for Kubernetes operator](https://github.com/CrunchyData/postgres-operator).

**_NOTE:_** You can use existing PostgreSQL database (if exists) or run your own PostgreSQL containers cluster without using the operator. Or you can use differnt operator from marketplace or opensource cummunity.

### Installing Crunchy Postgres for Kubernetes operator from the OpenShift OperatorHub

1. Go to **Operators** -> **OperatorHub** menu. Enter `postgres` into the search box, all relavent operators will show up on the screen. Then click on **Crunchy Postgres for Kubernetes operator**.

   ![PostgreSQL installation](images/postgres-operator-installation-1.png)

2. A panel with details of the operator will show up on the right. Then click **Install** button.

   ![PostgreSQL installation](images/postgres-operator-installation-2.png)

3. You can leave all options as default or change them if needed i.e. install the operator to the project you've created earlier. Then click **Install** button.

   ![PostgreSQL installation](images/postgres-operator-installation-3.png)

4. Wait until the operator gets installed successfully before proceeding to next steps.

   ![PostgreSQL installation](images/postgres-operator-installation-4.png)

   ![PostgreSQL installation](images/postgres-operator-installation-5.png)

### Deploying PostgreSQL database

1. Go to **Operators** -> **Installed Operators** menu, then select **Crunchy Postgres for Kubernetes**.

   ![Deploying PostgreSQL](images/postgres-deployment-1.png)

2. Select the project you've created earlier then click on **Postgres Cluster** tab, and then click on **Create PostgresCluster** button.

   ![Deploying PostgreSQL](images/postgres-deployment-2.png)

3. Switch to **YAML view**, then copy all content in [postgres.yml](postgres.yml) (simple cluster) or [postgres-ha.yml](postgres-ha.yml) (HA and connections pooling cluster) file to the editor. Then click on **Create** button. The operator will create a PostgreSQL database cluster for you.

   ![Deploying PostgreSQL](images/postgres-deployment-3.png)

   ![Deploying PostgreSQL](images/postgres-deployment-4.png)

4. Switch to Developer perspective, then go to **Topology** menu to verify that the database cluster is up and running.

   ![Deploying PostgreSQL](images/postgres-deployment-5.png)

5. Switch to Administrator perspective, then go to **Workloads** -> **Secrets** menu. Then look for the `postgres-pguser-service-registry` secret object and click on it.

   ![Deploying PostgreSQL](images/postgres-deployment-6.png)

6. Scroll down a bit and click on **Reveal values** link to see actual values in the secret object then note the **jdbc-uri**, **user**, and **password**. This will be used when deploying Service Registry.

   ![Deploying PostgreSQL](images/postgres-deployment-7.png)

## Red Hat Integration - Service Registry deployment

### Installing Service Registry from the OpenShift OperatorHub

1. Go to **Operators** -> **OperatorHub** menu. Enter `service registry` into the search box, the **Red Hat Integration - Service Registry Operator** will show up on the screen. Then click on it.

   ![Service Registry installation](images/service-registry-operator-installation-1.png)

2. A panel with details of the operator will show up on the right. Then click **Install** button.

   ![Service Registry installation](images/service-registry-operator-installation-2.png)

3. You can leave all options as default or change them if needed i.e. install the operator to the project you've created earlier. Then click **Install** button.

   ![Service Registry installation](images/service-registry-operator-installation-3.png)

4. Wait until the operator gets installed successfully before proceeding to next steps.

   ![Service Registry installation](images/service-registry-operator-installation-4.png)

### Configuring Service Registry with PostgreSQL database storage

1. Go to **Operators** -> **Installed Operators** menu, then select **Red Hat Integration - Service Registry Operator**.

   ![Deploying Service Registry](images/service-registry-deployment-1.png)

2. Select the project you've created earlier then click on **Apicurio Registry** tab, and then click on **Create ApicurioRegistry** button.

   ![Deploying Service Registry](images/service-registry-deployment-2.png)

3. Switch to **YAML view**, then copy all content in [apicurio.yml](apicurio.yml) file to the editor and update **username**, **password**, and **url** from the secret. Then click on **Create** button. The operator will deploy Service Registry for you.

   ![Deploying Service Registry](images/service-registry-deployment-3.png)

   ![Deploying Service Registry](images/service-registry-deployment-4.png)

4. Switch to Developer perspective, then go to **Topology** menu. You should be able to see the Service Registry pod. Click on the arrow icon to open Service Registry web console.

   ![Deploying Service Registry](images/service-registry-deployment-5.png)

   ![Deploying Service Registry](images/service-registry-deployment-6.png)

5. You can now start using the Service Registry via web console. However, Service Registry also can be interacted with using REST API. You can see the OpenAPI/Swagger specification by changing the URL to `/apis` as following screenshot.

   ![Deploying Service Registry](images/service-registry-deployment-7.png)

   ![Deploying Service Registry](images/service-registry-deployment-8.png)

## Testing Service Registry via REST API

Service Registry can be interacted with via 3 main methods:

1.  Web console
2.  REST API
3.  Client API (Programming)

### API testing using Postman

This guide has provide a [Postman](https://www.postman.com/) collection with some example of requests to interact with the Service Registry via REST API calls. You can import this [Postman collection](service-registry.postman_collection.json) and [Postman environment](service-registry.test.postman_environment.json) files to Postman application as explained in the Postman official guide [here](https://learning.postman.com/docs/getting-started/importing-and-exporting-data/).

![Postman](images/postman-1.png)

Postman collection use environment to store some variables i.e. hostname, API, group etc. which are used in each request in the collection. So, once you've imported the collection and environment files, you need to update the `SERVICE_REGISTRY_HOST` and `GROUP` variables in the Postman environment as a screenshot below before testing the Service Registry.

![Postman](images/postman-2.png)

### Performance testing using hey

[hey](https://github.com/rakyll/hey) is a tiny program that sends some load to a web application. You can use it to run simple performance testing. Please check hey [usage manual](https://github.com/rakyll/hey#usage) for command line options.

- Setup environment variables.

  ```sh
  export SERVICE_REGISTRY_BASE_URL="http://service-registry-service.test.svc:8080"
  export SCHEMA_GROUP="performance-test"
  ```

  **_NOTE:_** The base URL in your cluster might be different than this. Also, if you're running hey outside the cluster then the base URL should be the same as Service Registry's route.

- Testing create artifact API.

  - Create a payload i.e. [json-schema.json](json-schema.json) file to be created in Service Registry.

  - Run hey command to execute the test.

    ```sh
    ./hey -n 1000 -c 50 \
    -m POST \
    -D "json-schema.json" \
    -T "application/json" \
    -H "X-Registry-ArtifactType: JSON" \
    $SERVICE_REGISTRY_BASE_URL/apis/registry/v2/groups/$SCHEMA_GROUP/artifacts
    ```

- Testing get artifact API.

  - Grab one of schema ID from the Service Registry web console and export as an environment variable.

    ```sh
    export SCHEMA_ID="000427c8-080f-4300-9ea6-cb8aee64b922"
    ```

  - Run hey command to execute the test.

    ```sh
    ./hey -n 1000 -c 100 \
      -m GET $SERVICE_REGISTRY_BASE_URL/apis/registry/v2/groups/$SCHEMA_GROUP/artifacts/$SCHEMA_ID
    ```