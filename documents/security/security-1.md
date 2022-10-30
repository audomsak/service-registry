# Securing Service Registry using Red Hat Single Sign-On

This section describes how to install and setup Red Hat Single Sign-On using the Red Hat Single Sign-On Operator. The operator automates Red Hat Single Sign-On administration in Openshift. You use this Operator to create custom resources (CRs), which automate administrative tasks. For example, instead of creating a client or a user in the Red Hat Single Sign-On admin console, you can create custom resources to perform those tasks. A custom resource is a YAML file that defines the parameters for the administrative task.

This section will show how to configure a Service Registry REST API and web console to be protected by Red Hat Single Sign-On. Please note that Service Registry supports the following user roles:

| **Name**     | **Capabilities**                                                                                                                    |
|--------------|-------------------------------------------------------------------------------------------------------------------------------------|
| `sr-admin`     | Full access, no restrictions.                                                                                                       |
| `sr-developer` | Create artifacts and configure artifact rules. Cannot modify global rules, perform import/export, or use `/admin`  REST API endpoint. |
| `sr-readonly`  | View and search only. Cannot modify artifacts or rules, perform import/export, or use   `/admin`  REST API endpoint.                  |