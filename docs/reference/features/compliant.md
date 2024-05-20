# Compliant Cloud


> :material-check: Feature is in production and fully supported
>
> :material-timer-sand: Feature is in deployment, not yet supported
>
> :material-logout: Feature is deprecated, being phased out
>
> :material-close: Feature is not available


## Block storage

|                                                                 | Sto1HS           | Sto2HS           |
| ------------------------------                                  | ---------------- | ---------------- |
| Highly available storage                                        | :material-check: | :material-check: |
| [High-performance local storage](../flavors/index.md#compute-tiers)  | :material-check: | :material-check: |
| [Volume encryption](../../howto/openstack/cinder/encrypted-volumes.md) | :material-check: | :material-check: |


## Object storage

|                                                         | Sto1HS           | Sto2HS           |
| ------------------------------                          | ---------------- | ---------------- |
| S3 API                                                  | :material-check: | :material-check: |
| S3 [SSE-C](../../howto/object-storage/s3/sse-c.md)             | :material-check: | :material-check: |
| S3 [object lock](../../howto/object-storage/s3/object-lock.md) | :material-check: | :material-check: |
| Swift API                                               | :material-check: | :material-check: |


## Networking (Layer 2/3)

|                      | Sto1HS           | Sto2HS           |
| -------------------- | ---------------- | ---------------- |
| IPv4 (with NAT)      | :material-check: | :material-check: |
| IPv6                 | :material-timer-sand: | :material-close: |
| VPN (IPsec with PSK) | :material-check: | :material-check: |


## Load Balancers

|                                                                                                             | Sto1HS           | Sto2HS           |
| --------------------------------------------------------------------                                        | ---------------- | ---------------- |
| Transport layer (TCP/UDP)                                                                                   | :material-check: | :material-check: |
| Application layer (HTTP)                                                                                    | :material-check: | :material-check: |
| Application layer ([HTTPS, with secrets management for TLS certificates](../../howto/openstack/octavia/tls-lb.md)) | :material-check: | :material-check: |
| [Metrics endpoint](../../howto/openstack/octavia/metrics.md)                                                | :material-check: | :material-check: |
