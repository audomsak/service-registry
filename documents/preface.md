# Red Hat® Integration - Service Registry

**Red Hat® Integration - [Service Registry](https://www.redhat.com/en/topics/integration/what-is-a-service-registry)** is a service that provides an API and schema registry for applications i.e. microservices. Service Registry makes it easy for development teams to publish, discover, and reuse APIs and schemas.

Well-defined API and schema definitions are essential to delivering robust microservice and event streaming architectures. Development teams can use a registry to manage these artifacts in various formats, including OpenAPI, AsyncAPI, Apache Avro, Protocol Buffers, and more. Data producers and consumers can then use the artifacts to validate and serialize or deserialize data.

This installation guide will show you how to install **Red Hat® Integration - Service Registry** on [Red Hat® OpenShift Container Platform](https://www.redhat.com/en/technologies/cloud-computing/openshift/container-platform) and use PostgreSQL as a storage for the Service Registry. Though, [Red Hat® AMQ Streams](https://www.redhat.com/en/resources/amq-streams-datasheet) can also be used as the storage as well. Please check [offcial document](https://access.redhat.com/documentation/en-us/red_hat_integration/2021.q3/html/installing_and_deploying_service_registry_on_openshift/index) for more details.

## Testing Environment

- Red Hat OpenShift Container Platform 4.8
- Crunchy Postgres for Kubernetes operator 5.0.4
- Red Hat Integration - Service Registry Operator 2.0.4
- Red Hat Single Sign-On Operator 7.6.0-opr-002
