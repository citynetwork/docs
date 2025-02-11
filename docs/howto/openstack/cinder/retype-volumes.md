---
description: Changing the type of a volume ("retyping") is an offline operation that requires detaching the volume from its server, and setting its new type.
---
# Changing a volume's type

You may occasionally need to change the type of a volume.
This may be due to a volume type being phased out on {{brand}}'s part, necessitating data migration.
Or you might want to enable or disable [volume-level encryption](encrypted-volumes.md).

{{page.meta.description}}
The process of volume retyping incurs a short downtime.
Depending on the kind of application the server hosts, when you need to retype volumes, you should plan ahead well in advance.

## Prerequisites

In order to retype volumes, you must use the OpenStack CLI, so make sure you [have it enabled](../../getting-started/enable-openstack-cli.md).

## Checking the volume's state

Assume you have a volume named `testvol` that is currently attached to a server named `testsrv`:

```console
$ openstack volume list --long
+--------------+---------+--------+------+-------------+----------+--------------+------------+
| ID           | Name    | Status | Size | Type        | Bootable | Attached to  | Properties |
+--------------+---------+--------+------+-------------+----------+--------------+------------+
| 0e6f15f8-    | testvol | in-use |   75 | cbs-premium | false    | Attached to  |            |
| 8105-4043-   |         |        |      |             |          | testsrv on   |            |
| beb1-        |         |        |      |             |          | /dev/vdb     |            |
| 43f2364460f2 |         |        |      |             |          |              |            |
+--------------+---------+--------+------+-------------+----------+--------------+------------+
```

In this example, this volume status is `in-use`, meaning it is currently attached to a server, and the volume type is `cbs-premium`.

## Detaching the volume

You cannot retype a volume while it is attached to a server.
You must thus detach it first.
It is safest to do this while the server is shut down:

```console
$ openstack server stop testsrv

$ openstack server list -c Name -c Status
+---------+---------+
| Name    | Status  |
+---------+---------+
| testsrv | SHUTOFF |
+---------+---------+
```

Once your server is in the `SHUTOFF` state, you can safely proceed to detaching the volume.
This will change the volume status from `in-use` to `available`.

```console
$ openstack server remove volume testsrv testvol

$ openstack volume list
+--------------------------------------+---------+-----------+------+-------------+
| ID                                   | Name    | Status    | Size | Attached to |
+--------------------------------------+---------+-----------+------+-------------+
| 0e6f15f8-8105-4043-beb1-43f2364460f2 | testvol | available |   75 |             |
+--------------------------------------+---------+-----------+------+-------------+
```

## Retyping the volume

With the volume safely detached, you can now change its volume type.
If you were to change the volume type from `cbs-premium` to `cbs-standard`, you would proceed as follows:

```console
$ openstack volume set --type cbs-standard --migration-policy on-demand testvol

$ openstack volume list --long
+-------------+---------+-----------+------+-------------+----------+-------------+------------+
| ID          | Name    | Status    | Size | Type        | Bootable | Attached to | Properties |
+-------------+---------+-----------+------+-------------+----------+-------------+------------+
| 0e6f15f8-   | testvol | available |   75 | cbs-        | false    |             |            |
| 8105-4043-  |         |           |      | standard    |          |             |            |
| beb1-       |         |           |      |             |          |             |            |
| 43f2364460f |         |           |      |             |          |             |            |
| 2           |         |           |      |             |          |             |            |
+-------------+---------+-----------+------+-------------+----------+-------------+------------+
```

## Re-attaching the volume

Once retyping is complete and the volume is in the `available` status, you can re-attach it to the server:

```console
$ openstack server add volume testsrv testvol

+-----------------------+--------------------------------------+
| Field                 | Value                                |
+-----------------------+--------------------------------------+
| ID                    | 0e6f15f8-8105-4043-beb1-43f2364460f2 |
| Server ID             | 42049bba-3a48-4bc3-9940-bcaca120ec74 |
| Volume ID             | 0e6f15f8-8105-4043-beb1-43f2364460f2 |
| Device                | /dev/vdb                             |
| Tag                   | None                                 |
| Delete On Termination | False                                |
+-----------------------+--------------------------------------+
```

Finally, start the server:

```console
$ openstack server start testsrv

$ openstack server list -c Name -c Status
+---------+--------+
| Name    | Status |
+---------+--------+
| testsrv | ACTIVE |
+---------+--------+
```
