---
description: Reference documentation for the OpenStack API is available from the OpenStack website.
---
# OpenStack API reference documentation

For a starting point on reference information about the OpenStack APIs in {{brand}}, and how to use them with a tool like `curl`, refer to the OpenStack [API documentation landing page](https://docs.openstack.org/api-quick-start/).
Individual service APIs have their own detailed API reference documentation pages, such as those for the [Compute (Nova) API](https://docs.openstack.org/api-ref/compute/) or the [Networking (Neutron) API](https://docs.openstack.org/api-ref/network/v2/).

You may also be interested in the [API Quick Start Guide](https://docs.openstack.org/api-quick-start/api-quick-start.html) for information about how to authenticate against the OpenStack API, and send API requests.

> To access the OpenStack API in {{brand}}, you need to have an [account](../../../howto/getting-started/create-account.md), and also download a valid credentials file, as you would for [enabling the OpenStack CLI](../../../howto/getting-started/enable-openstack-cli.md).
> All actions exposed via the OpenStack CLI are also available by calling the API directly.

## OpenStack API endpoints

The {{brand}} {{api_region}} region exposes the following OpenStack API endpoints:

| Service Name | Service Type    | URL                                                             |
| ------------ | ------------    | ---                                                             |
| barbican     | key-manager     | <https://key-manager.{{api_region|lower}}.{{api_domain}}/>      |
| cinderv3     | volumev3        | <https://volume.{{api_region|lower}}.{{api_domain}}/>           |
| octavia      | load-balancer   | <https://load-balancer.{{api_region|lower}}.{{api_domain}}/>    |
| keystone     | identity        | <https://identity.{{api_region|lower}}.{{api_domain}}/>         |
| radosgw      | object-store    | <https://object-store.{{api_region|lower}}.{{api_domain}}/swift/> |
| placement    | placement       | <https://placement.{{api_region|lower}}.{{api_domain}}/>        |
| heat         | orchestration   | <https://orchestration.{{api_region|lower}}.{{api_domain}}/>    |
| neutron      | network         | <https://network.{{api_region|lower}}.{{api_domain}}/>          |
| nova         | compute         | <https://compute.{{api_region|lower}}.{{api_domain}}/>          |
| glance       | image           | <https://image.{{api_region|lower}}.{{api_domain}}/>            |

## OpenStack SDKs

Although the OpenStack API is perfectly usable via direct HTTP/HTTPS requests to the API endpoints, *most* developers prefer to use one of the Software Development Kits (SDKs) that wrap the OpenStack API.
These SDKs are available for many languages:

* Python: [openstacksdk](https://docs.openstack.org/openstacksdk/latest/)
* Go: [Gophercloud](http://gophercloud.io/) (see also its [reference documentation](https://pkg.go.dev/github.com/gophercloud/gophercloud))
* .NET: [OpenStack.NET](https://www.openstacknetsdk.org/)
* PHP: [php-opencloud](https://php-openstack-sdk.readthedocs.io/en/latest/)
* Ruby: [fog](https://fog.github.io/) (see also its [OpenStack provider documentation](https://github.com/fog/fog-openstack/blob/master/docs/getting_started.md))
* Java: [OpenStack4j](https://openstack4j.github.io/)
* JavaScript/Node.js: [pkgcloud](https://github.com/pkgcloud/pkgcloud)

If your target language has a supported SDK, it may be advisable to use one of them rather than work with hand-crafted HTTP/HTTPS requests.
