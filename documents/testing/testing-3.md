# Performance testing using hey

[**hey**](https://github.com/rakyll/hey) is a tiny program that sends some load to a web application. You can use it to run simple performance testing. Please check hey [usage manual](https://github.com/rakyll/hey#usage) for command line options.

- Setup environment variables.

  ```sh
  export SERVICE_REGISTRY_BASE_URL="http://service-registry-service.test.svc:8080"
  export SCHEMA_GROUP="performance-test"
  ```

  **_NOTE:_** The base URL in your cluster might be different than this. Also, if you're running `hey` outside the cluster then the base URL should be the same as Service Registry's route.

- Testing create artifact API.

  - Create a payload i.e. [json-schema.json](manifest/json-schema.json) file to be used for testing.

  - Run `hey` command to execute the test.

    ```sh
    ./hey -n 1000 -c 50 \
    -m POST \
    -D "json-schema.json" \
    -T "application/json" \
    -H "X-Registry-ArtifactType: JSON" \
    $SERVICE_REGISTRY_BASE_URL/apis/registry/v2/groups/$SCHEMA_GROUP/artifacts
    ```

    Sample output:

    ```text
    Summary:
    Total:        2.4149 secs
    Slowest:      0.2732 secs
    Fastest:      0.0126 secs
    Average:      0.1107 secs
    Requests/sec: 414.0978

    Total data:   261000 bytes
    Size/request: 261 bytes

    Response time histogram:
    0.013 [1]     |
    0.039 [68]    |■■■■■
    0.065 [29]    |■■
    0.091 [122]   |■■■■■■■■■
    0.117 [534]   |■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    0.143 [58]    |■■■■
    0.169 [9]     |■
    0.195 [141]   |■■■■■■■■■■■
    0.221 [35]    |■■■
    0.247 [2]     |
    0.273 [1]     |


    Latency distribution:
    10% in 0.0668 secs
    25% in 0.0932 secs
    50% in 0.1032 secs
    75% in 0.1164 secs
    90% in 0.1834 secs
    95% in 0.1919 secs
    99% in 0.2095 secs

    Details (average, fastest, slowest):
    DNS+dialup:   0.0003 secs, 0.0126 secs, 0.2732 secs
    DNS-lookup:   0.0001 secs, 0.0000 secs, 0.0062 secs
    req write:    0.0002 secs, 0.0000 secs, 0.0115 secs
    resp wait:    0.1102 secs, 0.0125 secs, 0.2730 secs
    resp read:    0.0001 secs, 0.0000 secs, 0.0009 secs

    Status code distribution:
    [200]   1000 responses
    ```

- Testing get artifact API.

  - Grab one of schema ID from the Service Registry web console and export as an environment variable.

    ```sh
    export SCHEMA_ID="000427c8-080f-4300-9ea6-cb8aee64b922"
    ```

  - Run `hey` command to execute the test.

    ```sh
    ./hey -n 10000 -c 100 \
      -m GET $SERVICE_REGISTRY_BASE_URL/apis/registry/v2/groups/$SCHEMA_GROUP/artifacts/$SCHEMA_ID
    ```

    Sample output:

    ```text
    Summary:
    Total:         8.9206 secs
    Slowest:       0.3318 secs
    Fastest:       0.0037 secs
    Average:       0.0860 secs
    Requests/sec:  1121.0042

    Total data:    65910000 bytes
    Size/request:  6591 bytes

    Response time histogram:
    0.004 [1]      |
    0.037 [2194]   |■■■■■■■■■■■■■■■■■■
    0.069 [84]     |■
    0.102 [4878]   |■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    0.135 [2018]   |■■■■■■■■■■■■■■■■■
    0.168 [9]      |
    0.201 [741]    |■■■■■■
    0.233 [61]     |■
    0.266 [7]      |
    0.299 [5]      |
    0.332 [2]      |


    Latency distribution:
    10% in 0.0127 secs
    25% in 0.0804 secs
    50% in 0.0949 secs
    75% in 0.1036 secs
    90% in 0.1146 secs
    95% in 0.1846 secs
    99% in 0.1981 secs

    Details (average, fastest, slowest):
    DNS+dialup: 0.0001 secs, 0.0037 secs, 0.3318 secs
    DNS-lookup: 0.0000 secs, 0.0000 secs, 0.0123 secs
    req write:  0.0001 secs, 0.0000 secs, 0.0639 secs
    resp wait:  0.0855 secs, 0.0036 secs, 0.3317 secs
    resp read:  0.0003 secs, 0.0000 secs, 0.0983 secs

    Status code distribution:
    [200] 10000 responses
    ```
