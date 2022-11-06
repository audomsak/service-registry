# Enable Service Registry Role-Based Authorization

## Service Registry Configuration

1. Open OpenShift web console, switch to **Administrator** perspective, and make sure you've selected `service-registry` project (or the project you've install Service Registry). Select **Workloads -> Deployments** menu, then click on `service-registry-deployment` link.

    ![Service Registry Configuration](../../images/service-registry-authn-authz-18.png)

2. Go to **Environment** tab, click **Add more** to add a new environment variable. Enter `ROLE_BASED_AUTHZ_ENABLED` as a name and `true` as its value, then click **Save** button.

    ![Service Registry Configuration](../../images/service-registry-authn-authz-19.png)

## Configuring Keycloak client

1. Open SSO web console, select **Registry** realm (or the realm you used for Service Registry). Select **Clients** menu then click on the client you need to configure.

    ![Configuring Keycloak client](../../images/service-registry-authn-authz-20.png)

2. Make sure the **Access Type** is `confidential` and **Service Accounts Enabled** option is `ON`

    ![Configuring Keycloak client](../../images/service-registry-authn-authz-21.png)

3. Go to **Service Account Roles** tab and assign one of valid roles (`sr-admin`, `sr-developer`, `sr-readonly`) for the client.

    ![Configuring Keycloak client](../../images/service-registry-authn-authz-22.png)

## Testing

1. Use Postman to get a token from Red Hat SSO. Then try to call the API that's not allowed for the current role assigned to client, in this case, client with `sr-readonly` role is not allowed to create artefact. The API call should be failed as a screenshot below for example.

    ![Testing](../../images/service-registry-authn-authz-23.png)

2. For Kafka Java client application, Authorization error should be thrown when the client application is trying to perform any operation that's not allowed for it's role.

    ```log
    Exception in thread "main" io.apicurio.rest.client.auth.exception.ForbiddenException: Authorization error
        at io.apicurio.registry.rest.client.impl.ErrorHandler.handleErrorResponse(ErrorHandler.java:57)
        at io.apicurio.rest.client.handler.BodyHandler.lambda$toSupplierOfType$1(BodyHandler.java:46)
        at io.apicurio.rest.client.JdkHttpClient.sendRequest(JdkHttpClient.java:204)
        at io.apicurio.registry.rest.client.impl.RegistryClientImpl.createArtifact(RegistryClientImpl.java:263)
        at io.apicurio.registry.rest.client.RegistryClient.createArtifact(RegistryClient.java:134)
        at io.apicurio.registry.resolver.DefaultSchemaResolver.lambda$handleAutoCreateArtifact$2(DefaultSchemaResolver.java:236)
        at io.apicurio.registry.resolver.ERCache.lambda$getValue$0(ERCache.java:142)
        at io.apicurio.registry.resolver.ERCache.retry(ERCache.java:181)
        at io.apicurio.registry.resolver.ERCache.getValue(ERCache.java:141)
        at io.apicurio.registry.resolver.ERCache.getByContent(ERCache.java:121)
        at io.apicurio.registry.resolver.DefaultSchemaResolver.handleAutoCreateArtifact(DefaultSchemaResolver.java:234)
        at io.apicurio.registry.resolver.DefaultSchemaResolver.getSchemaFromRegistry(DefaultSchemaResolver.java:115)
        at io.apicurio.registry.resolver.DefaultSchemaResolver.resolveSchema(DefaultSchemaResolver.java:88)
        at io.apicurio.registry.serde.AbstractKafkaSerializer.serialize(AbstractKafkaSerializer.java:83)
        at org.apache.kafka.clients.producer.KafkaProducer.doSend(KafkaProducer.java:925)
        at org.apache.kafka.clients.producer.KafkaProducer.send(KafkaProducer.java:885)
        at org.apache.kafka.clients.producer.KafkaProducer.send(KafkaProducer.java:773)
    ```

3. You can optionally go to [jwt.io](https://jwt.io/) website and decode the token returned from SSO. You'll see the `roles` contains only the role you assgined for the client.

    ![Testing](../../images/service-registry-authn-authz-24.png)

## References

- [Service Registry role-based authorization](https://access.redhat.com/documentation/en-us/red_hat_integration/2022.q3/html/installing_and_deploying_service_registry_on_openshift/securing-the-registry#registry-security-rbac-enabled)

- [Managing Service Registry environment variables](https://access.redhat.com/documentation/en-us/red_hat_integration/2022.q3/html/installing_and_deploying_service_registry_on_openshift/managing-the-registry#manage-registry-environment-variables)
