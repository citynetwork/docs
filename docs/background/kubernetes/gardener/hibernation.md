---
description: Background information on hibernation in Gardener clusters
---
# Hibernation

When you put a Gardener cluster in hibernation, what really happens is
that all worker nodes are destroyed. So for as long as the cluster is in
hibernation, you will not be paying for CPU, RAM, and boot volume
storage utilization incurred by the worker nodes. But there might still
be resources created by the cluster, for which you will keep getting
charged even when the cluster is in hibernation. More specifically, you
will keep paying for any persistent volumes, floating IPs, and load
balancers associated with the cluster.

Since the hibernated worker nodes are essentially wiped off, when you
wake a Gardener-based cluster up, it will have to re-fetch any images
its Pods previously ran on. That is because the image cache of newly
created worker nodes starts empty. Consequently, please keep in mind
that a cluster whose resources were perfectly humming along *before* the
hibernation, might suddenly see Pods failing with `ImagePullError` if
any image they depend on has been deleted in an upstream registry.

Last but not least, the act of waking a cluster up may temporarily fail,
because while the cluster was hibernating, the tenant came close to its
volume, RAM, CPU, etc. quota, and attempting to re-instantiate the
worker nodes and re-activate the cluster would breach the quota limit.

All of the above change many assumptions about the concept of
"hibernation", which usually means that resources are merely
stopped/frozen, and their volatile information is made persistent. This
is eminently **not** the case in Gardener hibernation.

Let us now see how you can hibernate a cluster from the {{gui}}, and
then how you can wake up an already hibernated cluster.

