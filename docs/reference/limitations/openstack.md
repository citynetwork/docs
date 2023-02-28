# OpenStack service limitations


## OpenStack users, groups, and roles

### Administrative privileges

No OpenStack user that you create while [enabling the OpenStack CLI](../../howto/getting-started/enable-openstack-cli.md) ever gets privileges exceeding administrative rights bound to a project.

This means that you cannot use an OpenStack user to *create* a new project.
You must do so via the {{gui}}, or the [{{rest_api}}](../api/cc/index.md).

It also means that you cannot use the following `openstack` CLI commands; they all return `Unauthorized` (HTTP 403):

* `openstack user [create|delete|list|set]`.
  > You can use `openstack user show` and `openstack user password set`, but only for your own user account.
* `openstack group <subcommand>`
* `openstack role <subcommand>`
* `openstack project <subcommand>` (except `list`).
  > You can use `openstack project list`, but this will only list the project(s) that your user account has access to.
* `openstack domain <subcommand>`


## Octavia

### Dual-stack support

A single load balancer managed by OpenStack Octavia can support IPv4 *or* IPv6, but not both.
To expose a service via IPv4 *and* IPv6, you must set up two separate load balancers pointing to the same backend.

## Designate

The [OpenStack Designate](https://docs.openstack.org/designate/) DNS-as-a-service (DNSaaS) facility is currently not available in {{brand}}.
You must manage your own DNS records for public IP addresses.

## Manila

The [OpenStack Manila](https://docs.openstack.org/designate/) filesystem-as-a-service (FSaaS) facility is currently not available in {{brand}}.
If you require multiple servers to be able to access the same files, [create a server](../../howto/openstack/nova/new-server.md) that exposes an internal NFS or CIFS service, backed by a Cinder volume.
