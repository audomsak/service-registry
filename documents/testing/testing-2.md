# REST API testing using Postman

This guide has provided a [Postman](https://www.postman.com/) collection with some example of requests to interact with the Service Registry via REST API calls. You can import the [Postman collection](postman/service-registry.postman_collection.json) and [Postman environment](postman/service-registry.test.postman_environment.json) files to Postman application as explained in the Postman official guide [here](https://learning.postman.com/docs/getting-started/importing-and-exporting-data/).

![Postman](images/postman-1.png)

Postman collection uses environment to store some variables i.e. hostname, API, group etc. which are used by each request in the collection. So, once you've imported the collection and environment files, you need to update the `SERVICE_REGISTRY_HOST` and `GROUP` variables in the Postman environment as a screenshot below before testing the Service Registry.

![Postman](images/postman-2.png)
