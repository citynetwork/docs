---
description: How to adjust the number of CPU cores and amount of memory for a virtual server
---
# Resizing a server

This guide will walk you through the required steps to change the
number of CPU cores and the amount of memory your server has access
to, this is done by changing the server's
[flavor](../../../reference/flavors/index.md).

[Resize](https://docs.openstack.org/nova/latest/admin/configuration/resize.html)
(or Server resize) is the ability to change the flavor of a server,
thus allowing it to upscale or downscale according to user needs. A
resize operation is a two-step process for the user:

1. Initiate the resize.
2. Either confirm (verify) success and release the old server, or
   declare a revert to release the new server and restart the old one.

## Prerequisites

You need to have a server you wish to resize. Additionally, if you
prefer to work with the OpenStack CLI, then make sure to properly
[enable it first](../../getting-started/enable-openstack-cli.md).

## Listing available flavors

=== "{{gui}}"
    Navigate to the server list.

    ![The left hand side navigation panel, with the word "Servers"
    highlighted.](assets/resize-server/01-left-side-panel.png)

    Find the server you want to resize in the list, and on the
    right-hand side click on its menu button.

    ![An orange circle with three white
    dots.](assets/resize-server/02-menu-button.png)

    Click on _Modify Server_.

    ![A list of server actions, with the line "Modify Server"
    highlighted.](assets/resize-server/03-menu-list.png)

    On this panel near the top, find the section called _Flavor_. This
    is the current flavor used by the server. Press on the dropdown
    menu to see all available flavors.

    ![A panel displaying the servers current flavor, 8 Cores and 24 GB
    RAM with the name of the flavor "b.8c24gb" within
    parenthesis.](assets/resize-server/04-modify-server.png)
=== "OpenStack CLI"
    To list all available flavors you can simply run `openstack flavor
    list`, but that will return a very long unsorted list, instead we
    recommend the following command:

    ```bash
    openstack flavor list -c Name -f value | grep '[0-9]c[0-9]' | sort -V
    ```

    The printout is a simple and clean list, sorted by the compute
    type, the number of cores and then by the amount of memory.

    ```plain
    b.1c1gb
    b.1c2gb
    b.1c4gb
    b.2c2gb
    b.2c4gb
    b.2c8gb
    b.2c16gb
    b.4c4gb
    ...
    ```

## Initiating the resize

Choose a new flavor that you want your server to use instead.

> A resize is only possible with [flavors](../../../reference/flavors/index.md) using
> the same prefix letter. Most commonly you will have a `b.` flavor,
> thus you must select another `b.` flavor.

=== "{{gui}}"
    Once selected, the _Resize_ button will appear.

    ![A panel displaying the servers new flavor, 4 Cores and 24 GB RAM
    with the name of the flavor "b.4c24gb" within parenthesis, also a
    green button below it with the text
    "Resize".](assets/resize-server/05-resize-button.png)

    Click on it to start the resize.

    While the resize is ongoing you will see a spinning circle saying
    _Resize is in progress_.

    ![A spinning circle with the text "Resize in
    progress...".](assets/resize-server/06-resize-in-progress.png)
=== "OpenStack CLI"
    To start the resize use the following command:

    ```bash
    openstack server resize --flavor <new_flavor> <server_id>
    ```

    While the resize is ongoing the server should have the
    `OS-EXT-STS:task_state` of `resize_migrating` and the `status` of
    `RESIZE`.

    ```bash
    openstack server show -c OS-EXT-STS:task_state -c OS-EXT-STS:vm_state -c status <server_id>
    ```

    ```plain
    +-----------------------+------------------+
    | Field                 | Value            |
    +-----------------------+------------------+
    | OS-EXT-STS:task_state | resize_migrating |
    | OS-EXT-STS:vm_state   | active           |
    | status                | RESIZE           |
    +-----------------------+------------------+
    ```

    You may proceed with the next step once your server status is
    `VERIFY_RESIZE`.

    ```plain
    +-----------------------+---------------+
    | Field                 | Value         |
    +-----------------------+---------------+
    | OS-EXT-STS:task_state | None          |
    | OS-EXT-STS:vm_state   | resized       |
    | status                | VERIFY_RESIZE |
    +-----------------------+---------------+
    ```

The resize process might take a minute or more. {{brand}} will
now make a restore point in case the resize process fails. It would
then restore your server to the state it was before the resize.

## Confirming the resize

Your server is now using the new flavor you selected earlier, and you
need to make sure the server is working as intended after the resize.

Once you are certain your server is working as intended, you should
confirm the resize. If you do not confirm the resize, your server will
automatically have the resize confirmed after 24 hours.

=== "{{gui}}"
    This is done by clicking the _Confirm_ button.

    ![A panel displaying the servers flavor, 4 Cores and 24 GB RAM
    with the name of the flavor "b.4c24gb" within parenthesis, a red
    button with the text "Cancel" below it and a green button with the
    text "Confirm" beside
    that.](assets/resize-server/07-resize-confirm.png)

    > If your server is not working as intended, or you simply regret
    > the resize, instead click _Cancel_.
=== "OpenStack CLI"
    This is done by using the following command:

    ```bash
    openstack server resize confirm <server_id>
    ```

    Alternatively, if your server is not working as intended, revert
    the resize with the following command:

    ```bash
    openstack server resize revert <server_id>
    ```

This concludes the process of resizing a server in {{brand}}.
