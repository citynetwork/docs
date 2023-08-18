---
description: How to restore a server to a particular snapshot
---
# Restoring a server to a snapshot

Servers in {{brand}} that have the [disaster
recovery](../../../background/disaster-recovery.md) feature enabled can go back in
time, meaning you may restore such a server to one of the available
point-in-time snapshots. Here is how you can do that.

## How to restore, step by step

To select a particular snapshot and restore your server to it, first
off, navigate to the {{gui}}. From the left-hand side vertical pane,
choose Compute → [Servers](https://{{gui_domain}}/compute/servers), then
expand the detailed view of the server of interest. Select the *Disaster
Recovery* tab and see all available snapshots listed below. For each one
of those, the date and creation time are visible.

![All available snapshots for selected
server](assets/rest-srv-to-snap/disaster-recovery-available-snaps.png)

Click on the snapshot you want. A pop-up window will appear, asking for
your permission to proceed. Make sure this is indeed the snapshot you
want, then click the red button labeled *Yes, Restore snapshot*.

![Asking for permission to restore
snapshot](assets/rest-srv-to-snap/disaster-recovery-permission-to-proceed.png)

The restore process will begin immediately. You can tell it is
progressing by checking the status.

![Snapshot recovery in
progress](assets/rest-srv-to-snap/disaster-recovery-recover-in-progress.png)

As soon as the snapshot is ready to be used, you will see a message
indicating that it has started. Do not forget to activate the server;
click on its row to select it, then click the :fontawesome-solid-play:
button above.

![Start server to the
snapshot](assets/rest-srv-to-snap/disaster-recovery-boot-from-snapshot.png)
