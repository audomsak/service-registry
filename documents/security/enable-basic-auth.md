# Enable HTTP Basic Authentication

By default, Service Registry supports authentication using OpenID Connect. Users (or API clients) must obtain an access token to make authenticated calls to the Service Registry REST API. However, because some tools do not support OpenID Connect, you can also configure Service Registry to support HTTP basic authentication.

Apicurio Registry supports both OAuth and BASIC auth at the same time. a custom authentication handler has been implemented to use OAuth **client_credentials** flow to support BASIC auth. In other words, the client can provide BASIC auth credentials, and the server-side custom handler will extract the username/password and then use OAuth **client_credentials** flow against the Keycloak server to obtain an access token. Once that is done, everything else works the same as if the client had provided an OAuth bearer token to begin with.

To enable HTTP basic authentication, login to Service Registry web console with administrator privilege i.e. `registry-admin` account you've created in [this section](create-registry-realm.md). Go to **Settings** tab, then enable the **HTTP basic authentication** option.

![Enable HTTP basic authentication](../../images/service-registry-authn-authz-16.png)
