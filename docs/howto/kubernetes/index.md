# Kubernetes in Cleura

<!-- Config interpolation for the company name didn't work for the 
title here. -->

In {{company}} you can run Kubernetes in various
ways. [{{gui}}](https://{{gui_domain}}) includes management
interfaces for [Gardener](https://gardener.cloud/) and
[OpenStack Magnum](https://docs.openstack.org/magnum/).

### Gardener

Gardener is a Kubernetes-native system that provides automated 
management and operation of Kubernetes clusters as a service.
It allows you to create clusters and automatically handle their 
lifecycle operations, including configurable maintenance windows,
hibernation schedules, and automatic updates to Kubernetes control 
plane and worker nodes.
You can read more about Gardener and its capabilities on its 
[documentation website](https://gardener.cloud/docs/gardener/).

To learn how to use Gardener in the {{gui}}, refer to
[Creating Kubernetes clusters using
{{gui}}](gardener/create-shoot-cluster.md).

### Magnum

Magnum lets you create clusters via the OpenStack APIs. To do that,
you base your configuration on a Cluster Template. The template
defines parameters describing how the cluster will be constructed,
such as worker flavors. In each region, we offer predefined public
Cluster Templates with ready-to-use configurations.  To learn more
about Cluster Templates, check out the
[Magnum documentation](https://docs.openstack.org/magnum/latest/user/#clustertemplate).

Once you have chosen your Cluster Template, you move on to 
[create a cluster based on that template](/howto/openstack/magnum/new-k8s-cluster).
When you create the cluster, you can define the number of nodes in
your cluster, ask for multiple master nodes with a load balancer
in front, etc.
