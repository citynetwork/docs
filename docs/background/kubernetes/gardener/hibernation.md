---
description: How hibernation of Gardener-based Kubernetes clusters works
---

# Hibernation

In {{brand}}, you have the option of putting a {{k8s_management_service}}-based Kubernetes
[cluster in
hibernation](../../../howto/kubernetes/gardener/hibernate-shoot-cluster.md).
This is something you might want to do whenever you know you won't be
needing the cluster for some time. Putting it in hibernation makes sense
because from that time on and before you wake it up, you pay *less* for
hosting.

You may wonder why you still pay *something* after putting a cluster in
hibernation, instead of paying nothing at all. To answer this question,
we have to explain how hibernation works.

## How hibernation works

Learning about the logic of hibernation in {{k8s_management_service}}, we immediately get
a fresh perspective on the whole concept. When we hear about
hibernation, we usually think of resources that are merely stopped or
frozen, and their volatile information made persistent. This is **not**
how {{k8s_management_service}} hibernation works --- and here's why.

When you put a {{k8s_management_service}} cluster in hibernation, what really happens is
that all worker nodes are **removed.** So, as long as the cluster is in
hibernation, you will not be paying for CPU, RAM, and boot volume
storage utilization incurred by the worker nodes. But there might still
be resources created by the cluster, for which you will keep getting
charged even when the cluster is in hibernation. More specifically, you
will keep paying for any persistent volumes, floating IPs, and load
balancers associated with the cluster.

In Kubernetes, a
[Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
(or *PV*), is a piece of storage in the cluster that has been
provisioned either dynamically (using [Storage
Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/))
or by an administrator. When a user makes a request for storage, then we
have a
[PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)
(or *PVC*). Floating IPs, on the other hand, are instantiated to
be assigned to Kubernetes [Services](https://kubernetes.io/docs/concepts/services-networking/) that need a public IP. Those services
have an external load balancer (i.e., a service of `Type:
LoadBalancer`). When you hibernate a {{k8s_management_service}} cluster, objects of any of
those types are retained.

## Waking up clusters

When you wake a hibernated cluster, the previously removed worker
nodes reappear. Since all information about cluster resources
([Pods](https://kubernetes.io/docs/concepts/workloads/pods/),
[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/),
[ReplicaSets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
etc.) are still available on the control plane, these cluster
resources *also* automatically reappear on the recreated worker nodes.

However, to run your Pods, {{k8s_management_service}} will have to re-fetch any
images they previously ran on. That is because the image cache of
newly created worker nodes starts empty. Consequently, please keep in
mind that a cluster whose resources were perfectly humming along
*before* the hibernation, might suddenly see Pods failing with
`ImagePullError` if any image they depend on has been deleted in an
upstream registry.

Last but not least, the act of waking a cluster up may temporarily fail,
because while the cluster was hibernating, the tenant came close to its
volume, RAM, CPU, etc. quota, and attempting to re-instantiate the
worker nodes and re-activate the cluster would breach the [quota
limit](../../../reference/quotas/openstack.md).
