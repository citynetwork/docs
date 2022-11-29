# Magnum

Magnum lets you create clusters via the OpenStack APIs. To do that,
you base your configuration on a Cluster Template. The template
defines parameters describing how the cluster will be constructed,
such as worker flavors. In each region, we offer predefined public
Cluster Templates with ready-to-use configurations.  To learn more
about Cluster Templates, check out the [Magnum
documentation](https://docs.openstack.org/magnum/latest/user/#clustertemplate).

Once you have chosen your Cluster Template, you move on to [create a
cluster based on that
template](/howto/openstack/magnum/new-k8s-cluster).  When you create
the cluster, you can define the number of nodes in your cluster, ask
for multiple master nodes with a load balancer in front, etc.
