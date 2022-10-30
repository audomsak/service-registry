# Kafka Client

This section provides a few code snippets to configure Service Registry Kafka serializer/deserializer (SerDes) configuration properties to access the secure Service Registry server.

Apicurio Registry supports both OAuth and BASIC auth at the same time. a custom authentication handler has been implemented to use OAuth **client_credentials** flow to support BASIC auth. In other words, the client can provide BASIC auth credentials, and the server-side custom handler will extract the username/password and then use OAuth **client_credentials** flow against the Keycloak server to obtain an access token. Once that is done, everything else works the same as if the client had provided an OAuth bearer token to begin with.

Visit [official document](https://www.apicur.io/registry/docs/apicurio-registry/2.3.x/getting-started/assembly-configuring-kafka-client-serdes.html) for detailed information on how to configure Kafka SerDes in your producer and consumer Java client applications.

## Example Application

We're going to use [this example application](https://github.com/Apicurio/apicurio-registry-examples/tree/main/simple-avro) for demostration. Visit [Apicurio Registry Example Applications repository](https://github.com/Apicurio/apicurio-registry-examples) for more Java example applications.

### Kafka serializer/deserializer (SerDes) configuration properties

Based on the authentication mechanism you're using for Service Registry, you need to update the [example application code](https://github.com/Apicurio/apicurio-registry-examples/blob/main/simple-avro/src/main/java/io/apicurio/registry/examples/simple/avro/SimpleAvroExample.java) when creating Kaka [Producer](https://github.com/Apicurio/apicurio-registry-examples/blob/05cdb04fa839291956eec6701bee4818692bf504/simple-avro/src/main/java/io/apicurio/registry/examples/simple/avro/SimpleAvroExample.java#L136) and [Consumer](https://github.com/Apicurio/apicurio-registry-examples/blob/05cdb04fa839291956eec6701bee4818692bf504/simple-avro/src/main/java/io/apicurio/registry/examples/simple/avro/SimpleAvroExample.java#L163) object as the snippets below.

**Basic Authentication** configuration

```java
props.putIfAbsent(SerdeConfig.AUTH_USERNAME, "test-kafka-registry");
props.putIfAbsent(SerdeConfig.AUTH_PASSWORD, "93b77291-ccbb-4fc1-9264-562e8c421ffd");
```

**OAuth** configuration

```java
props.putIfAbsent(SerdeConfig.AUTH_CLIENT_ID, "test-kafka-registry");
props.putIfAbsent(SerdeConfig.AUTH_CLIENT_SECRET, "93b77291-ccbb-4fc1-9264-562e8c421ffd");
props.putIfAbsent(SerdeConfig.AUTH_TOKEN_ENDPOINT, "https://keycloak-service-registry.apps.cluster-qmkwt.qmkwt.sandbox19.opentlc.com/auth/realms/registry/protocol/openid-connect/token");
```

### Running Example Application

If the Kafka serializer/deserializer (SerDes) configuration properties are correct, you should be able to see application output similar to this when you run the application. This means the client application can connect and authenticate to Service Registry successfully.

```text
Starting example SimpleAvroExample
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
Producing (5) messages.
Messages successfully produced.
Closing the producer.
Creating the consumer.
Subscribing to topic SimpleAvroExample
Consuming (5) messages.
No messages waiting...
No messages waiting...
No messages waiting...
Consumed a message: Hello (0)! @ Sun Oct 30 13:40:42 ICT 2022
Consumed a message: Hello (1)! @ Sun Oct 30 13:40:44 ICT 2022
Consumed a message: Hello (2)! @ Sun Oct 30 13:40:44 ICT 2022
Consumed a message: Hello (3)! @ Sun Oct 30 13:40:44 ICT 2022
Consumed a message: Hello (4)! @ Sun Oct 30 13:40:44 ICT 2022
Done (success).

Process finished with exit code 0
```
