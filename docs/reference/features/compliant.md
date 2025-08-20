# Compliant Cloud


> :material-check: Feature is in production and fully supported
>
> :material-timer-sand: Feature is in deployment, not yet supported
>
> :material-logout: Feature is deprecated, being phased out
>
> :material-close: Feature is not available


The new Sto-Com region, also known as Compliant Cloud v2, implements certain technologies that significantly differentiate it from other {{brand}} regions.


## Availability zones

The Sto-Com region has three (3) availability zones (AZs) connected by a stretched Layer 2 network.
Resources are allocated randomly between the three whenever an AZ is **not** explicitly specified.
Each AZ has its own block storage, and no live migration between AZs is possible.


## Block storage

|                                                                 | Sto1HS           | Sto2HS           | Sto-Com          |
| ------------------------------                                  | ---------------- | ---------------- | ---------------- |
| Highly available storage                                        | :material-check: | :material-check: | :material-check: |
| [High-performance local storage](../flavors/index.md#compute-tiers)  | :material-check: | :material-check: | :material-check: |
| [Volume encryption](../../howto/openstack/cinder/encrypted-volumes.md) | :material-check: | :material-check: | :material-check: |

Volumes in Sto-Com are provided by Ceph.
Cloud servers with ephemeral storage have low-latency disks (LLDs) that are local to the corresponding hypervisor.

## Domain-based OpenStack endpoints

Instead of having different endpoints on different ports of the same domain name, Sto-Com offers different subdomain names per endpoint.

The following is a list of domain-based endpoints valid for Sto-Com:

| Service Name | Service Type    | URL                                               |
| ------------ | ------------    | ---                                               |
| barbican     | key-manager     | <https://key-manager.{{api_region|lower}}.{{api_domain}}/>       |
| cinderv3     | volumev3        | <https://volume.{{api_region|lower}}.{{api_domain}}/>            |
| octavia      | load-balancer   | <https://load-balancer.{{api_region|lower}}.{{api_domain}}/>     |
| keystone     | identity        | <https://identity.{{api_region|lower}}.{{api_domain}}/>          |
| radosgw      | object-store    | <https://object-store.{{api_region|lower}}.{{api_domain}}/>      |
| placement    | placement       | <https://placement.{{api_region|lower}}.{{api_domain}}/>         |
| heat         | orchestration   | <https://orchestration.{{api_region|lower}}.{{api_domain}}/>     |
| neutron      | network         | <https://network.{{api_region|lower}}.{{api_domain}}/>           |
| nova         | compute         | <https://compute.{{api_region|lower}}.{{api_domain}}/v2.1/>      |
| glance       | image           | <https://image.{{api_region|lower}}.{{api_domain}}/>             |


## Object storage

|                                                         | Sto1HS           | Sto2HS           | Sto-Com          |
| ------------------------------                          | ---------------- | ---------------- | ---------------- |
| S3 API                                                  | :material-check: | :material-check: | :material-check: |
| S3 [SSE-C](../../howto/object-storage/s3/sse-c.md)             | :material-check: | :material-check: | :material-check: |
| S3 [object lock](../../howto/object-storage/s3/object-lock.md) | :material-check: | :material-check: | :material-check: |
| Swift API                                               | :material-check: | :material-check: | :material-check: |

The Object Store in Sto-Com is configured so that data written in a container or a bucket are automatically stored and synchronized between all three availability zones.
Users may define policies so that a specific bucket is located in a single AZ.

> Contrary to other regions, where images live on Ceph RBD pools, images in Sto-Com reside in an object store.
> As a result, new VMs in Sto-Com may take longer to initialize.


## OVN Octavia provider

Sto-Com comes with two providers for Octavia: the Amphora Layer 7 Load Balancer (LB) and the OVN Layer 4 LB.
The Amphora LB is the default.


## Networking (Layer 2/3)

|                      | Sto1HS           | Sto2HS           | Sto-Com          |
| -------------------- | ---------------- | ---------------- | ---------------- |
| IPv4 (with NAT)      | :material-check: | :material-check: | :material-check: |
| IPv6                 | :material-timer-sand: | :material-close: | :material-close: |
| VPN (IPsec with PSK) | :material-check: | :material-check: | :material-close: |

In Sto-Com, Quality of Service in Neutron is configured for tenant networks, router gateways, and floating IPs:

| Port type                   | Bandwidth limit |
| --------------------------- | --------------- |
| VM ports (private networks) | 2 Gbps          |
| Floating IPs                | 1 Gbps          |
| Router Gateways             | 1 Gbps          |

## Load Balancers

|                                                                                                             | Sto1HS           | Sto2HS           | Sto-Com          |
| --------------------------------------------------------------------                                        | ---------------- | ---------------- | ---------------- |
| Transport layer (TCP/UDP)                                                                                   | :material-check: | :material-check: | :material-close: |
| Application layer (HTTP)                                                                                    | :material-check: | :material-check: | :material-check: |
| Application layer ([HTTPS, with secrets management for TLS certificates](../../howto/openstack/octavia/tls-lb.md)) | :material-check: | :material-check: | :material-check: |
| [Metrics endpoint](../../howto/openstack/octavia/metrics.md)                                                | :material-check: | :material-check: | :material-check: |
