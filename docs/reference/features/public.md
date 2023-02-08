# Public Cloud

> :material-check: Feature is in production and fully supported
>
> :material-timer-sand: Feature is in deployment, not yet supported
>
> :material-logout: Feature is deprecated, being phased out
>
> :material-close: Feature is not available


## Virtualization
|                                               | Kna1             | Sto2                  | Fra1             | Dx1              | Tky1             |
| -------------                                 | ---------------- | --------------------- | ---------------- | ---------------- | ---------------- |
| [Virtual GPU](../../flavors/#compute-tiers)   | :material-close: | :material-close:      | :material-close: | :material-close: | :material-close: |


## Block storage
|                                                                 | Kna1             | Sto2             | Fra1             | Dx1              | Tky1             |
| ------------------------------                                  | ---------------- | ---------------- | ---------------- | ---------------- | ---------------- |
| Highly available storage                                        | :material-check: | :material-check: | :material-check: | :material-check: | :material-check: |
| [High-performance local storage](../../flavors/#compute-tiers)  | :material-check: | :material-check: | :material-check: | :material-close: | :material-close: |
| [Volume encryption](/howto/openstack/cinder/encrypted-volumes/) | :material-check: | :material-check: | :material-check: | :material-check: | :material-check: |


## Object storage
|                                             | Kna1             | Sto2             | Fra1             | Dx1              | Tky1             |
| ------------------------------              | ---------------- | ---------------- | ---------------- | ---------------- | ---------------- |
| S3 API                                      | :material-check: | :material-close: | :material-check: | :material-check: | :material-close: |
| S3 [SSE-C](/howto/object-storage/s3/sse-c/) | :material-check: | :material-close: | :material-check: | :material-check: | :material-close: |
| Swift API                                   | :material-check: | :material-close: | :material-check: | :material-check: | :material-close: |


## Networking (Layer 2/3)
|                      | Kna1             | Sto2             | Fra1             | Dx1              | Tky1             |
| -------------------- | ---------------- | ---------------- | ---------------- | ---------------- | ---------------- |
| IPv4 (with NAT)      | :material-check: | :material-check: | :material-check: | :material-check: | :material-check: |
| IPv6                 | :material-check: | :material-check: | :material-check: | :material-check: | :material-check: |
| VPN (IPsec with PSK) | :material-check: | :material-check: | :material-check: | :material-check: | :material-check: |


## Load Balancers
|                                                                                                             | Kna1             | Sto2             | Fra1             | Dx1              | Tky1             |
| --------------------------------------------------------------------                                        | ---------------- | ---------------- | ---------------- | ---------------- | ---------------- |
| Transport layer (TCP/UDP)                                                                                   | :material-check: | :material-check: | :material-check: | :material-check: | :material-check: |
| Application layer (HTTP)                                                                                    | :material-check: | :material-check: | :material-check: | :material-check: | :material-check: |
| Application layer ([HTTPS, with secrets management for TLS certificates](/howto/openstack/octavia/tls-lb/)) | :material-check: | :material-check: | :material-check: | :material-check: | :material-check: |


## Kubernetes management
|                            | Kna1                  | Sto2                  | Fra1                  | Dx1              | Tky1             |
| -----------------          | ----------------      | ----------------      | ----------------      | ---------------- | ---------------- |
| OpenStack Magnum           | :material-check:      | :material-check:      | :material-check:      | :material-check: | :material-check: |
| {{k8s_management_service}} | :material-timer-sand: | :material-timer-sand: | :material-timer-sand: | :material-close: | :material-close: |
