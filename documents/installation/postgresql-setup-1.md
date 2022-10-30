# PostgreSQL database deployment

We're going to use PostgreSQL database as a storage for Service Registry so we need to setup the database first and make sure it's ready to use. There are plenty of options for PostgreSQL operators or containers that can be installed on OpenShift. You can use either commercial or community version that suites your environment and requirement. This guide will show you how to deploy PostgreSQL database using [Crunchy Postgres for Kubernetes operator](https://github.com/CrunchyData/postgres-operator).

**_NOTE:_** You can use existing PostgreSQL database (if exists) or run your own PostgreSQL containers cluster without using the operator. Or you can use differnt operator from marketplace or opensource community.
