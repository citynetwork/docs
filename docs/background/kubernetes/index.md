# Kubernetes in Cleura Cloud

{{brand}} has two management facilities for Kubernetes clusters:

* [{{brand_container_orchestration}}](../../howto/kubernetes/gardener/index.md),
* [OpenStack Magnum](../../howto/kubernetes/magnum/index.md).

In most scenarios, {{k8s_management_service}} is the preferred option, since it supports more recent Kubernetes versions and offers you a greater degree of "hands-off" management.

For more details on the relative merits of both options, refer to the sections below.

## General characteristics
|                                                                 | {{k8s_management_service}}   | Magnum                                |
| -------------                                                   | ----------------             | ----------------                      |
| Kubernetes Cloud Provider                                       | OpenStack                    | OpenStack                             |
| Base operating system for nodes                                 | Garden Linux                 | Fedora CoreOS                         |
| Latest installable Kubernetes minor release                     | 1.29                         | 1.24                                  |


## API and CLI support
|                                                                 | {{k8s_management_service}}   | Magnum                                |
| -------------                                                   | ----------------             | ----------------                      |
| Manageable via Cleura Cloud REST API                            | :material-check:             | :material-check:                      |
| Manageable via OpenStack REST API                               | :material-close:             | :material-check:                      |
| Manageable via OpenStack CLI                                    | :material-close:             | :material-check:                      |

## Updates and upgrades
|                                                                 | {{k8s_management_service}}   | Magnum                                |
| -------------                                                   | ----------------             | ----------------                      |
| Automatic update to new Kubernetes patch release                | :material-check:             | :material-close:                      |
| Rolling upgrade to new Kubernetes minor release                 | :material-check:             | :material-check:                      |
| Automatic upgrade to new Kubernetes minor release               | :material-close:             | :material-close:                      |
| Rolling upgrade to new base operating system release            | :material-check:             | :material-check:                      |
| Automatic upgrade to new base operating system release          | :material-check:             | :material-close:                      |

## Functional features
|                                                       | {{k8s_management_service}}          | Magnum                                |
| -------------                                         | ----------------                    | ----------------                      |
| Built-in private registry for container images        | :material-close:                    | :material-check:                      |
| [Hibernation](gardener/hibernation.md)                | :material-check:                    | :material-close:                      |
| Manual vertical scaling (bigger/smaller worker nodes) | :material-check:[^vertical-scaling] | :material-check:                      |
| Vertical autoscaling                                  | :material-close:                    | :material-close:                      |
| Manual horizontal scaling (more/fewer worker nodes)   | :material-check:                    | :material-check:                      |
| Horizontal [autoscaling](gardener/autoscaling.md)     | :material-check:                    | :material-check:[^cluster-autoscaler] |
| Kubernetes dashboard                                  | :material-check:[^dashboard]        | :material-check:                      |

[^vertical-scaling]: Vertical scaling is only supported via defining additional worker node groups.

[^cluster-autoscaler]: You must deploy [Magnum Cluster Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/magnum/README.md) to use horizontal autoscaling.

[^dashboard]: You must separately [deploy](https://github.com/kubernetes/dashboard/#install) the Kubernetes Dashboard.

## Charges and billing
|                                                                 | {{k8s_management_service}}   | Magnum                                |
| -------------                                                   | ----------------             | ----------------                      |
| Monthly subscription fee                                        | :material-check:             | :material-close:                      |
| {{brand}} charges for Kubernetes control plane nodes            | :material-close:             | :material-check:                      |
| {{brand}} charges for Kubernetes worker nodes                   | :material-check:             | :material-check:                      |

