# Kubernetes in Cleura

<!-- Config interpolation for the company name didn't work for the title here. -->

In {{config.extra.company}} you can run Kubernetes in various
ways. [{{config.extra.gui}}](https://{{config.extra.gui_domain}})
includes management interfaces for [Gardener](https://gardener.cloud/)
and [OpenStack Magnum](https://docs.openstack.org/magnum/).

### Gardener

Gardener is a Kubernetes-native system that provides automated management and operation of Kubernetes clusters as a service.
It allows you to create clusters and automatically handle their lifecycle operations, including configurable maintenance windows,
hibernation schedules, and automatic updates to Kubernetes control plane and worker nodes.
You can read more about Gardener and its capabilities on its [documentation website](https://gardener.cloud/docs/gardener/).

To learn how to use Gardener in the {{config.extra.gui}}, refer to
[Creating Kubernetes clusters using
{{config.extra.gui}}](gardener/create-shoot-cluster.md).

### Magnum

Magnum lets you create clusters via the OpenStack APIs. To do that, you base your configuration on a Cluster Template. In the template
you define parameters that describe how the cluster will be constructed, for example worker flavors. In each our regions we offer
predefined public Cluster Templates with ready to use configurations. To learn more about the templates, check
out the [Magnum documentation](https://docs.openstack.org/magnum/latest/user/#clustertemplate).

Once you have chosen or created your Cluster Template, you move on to create a cluster based on that template. When you create the cluster,
you have the possibility to define the number of nodes in your cluster, if you would like to have multiple master nodes with a load balancer
in front etc.
