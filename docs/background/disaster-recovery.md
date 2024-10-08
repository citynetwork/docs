---
description: What is the Disaster Recovery feature and why you want it
---
# Disaster recovery

When you [create a new server](../howto/openstack/nova/new-server.md) in
{{brand}} you will notice an option named **Disaster recovery**, which
is enabled by default.

![Disaster recovery is enabled by default for new
servers](assets/disaster-recovery-option-on-by-default.png)

Even if you choose to disable it for a particular server, keep in mind
that you have the option to enable it at a later time.

![The disaster recovery feature can be manually activated for any
server](assets/disaster-recovery-option-manual-activation.png)

In the following, we explain what this option does, how it works in the
background, and why you should consider enabling it.

## What it is

The *Disaster Recovery* (DR) feature is available via the {{gui}} and
applies to servers and volumes that use our [Ceph](https://docs.ceph.com/)
backend. That would be **all** servers but the ones of the `s`
[flavor](../reference/flavors/index.md#compute-tiers).

## How it works

As soon as you enable DR for a server or a single volume, you start
getting snapshots for the corresponding [*RADOS Block Device*
(RBD)](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Block-Device)
image. Those snapshots are created automatically once per day, and you
always have the snapshots of the last 10 days.

Please keep in mind that all RBD snapshots are created in the same Ceph
cluster and are not replicated remotely. If, for any reason, you delete
the original volume, then all snapshots will also be deleted, and the
snapshot creation schedule will be canceled immediately.

## Why enable it

Provided snapshots are available, you can restore a server or a single
volume to any of those snapshots. For instance, you may discover that
due to faulty application logic or simply a bug, you are now
experiencing data corruption. Then, one of your options would be to [go
back in time](../howto/openstack/nova/restore-srv-to-snap.md) by restoring
one of the available snapshots and keep going from there.

## Restoration time

You should know that the DR feature creates *point-in-time* snapshots on
the storage level. The time required to restore a server to a particular
snapshot depends on its size. During restoration, the server is shut
off. After the restore, you need to power the server back on manually.
Although this whole process takes time analogous to volume size, as we
pointed out, we should also note that it only takes seconds to complete
on average.
