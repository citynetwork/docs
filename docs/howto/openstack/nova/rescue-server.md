---
description: How to access a virtual server in rescue mode
---
# Rescuing a server

This guide will walk you through the required steps to access a server
in
[rescue mode](https://docs.openstack.org/nova/latest/user/rescue.html)
when you need to.

You can use rescue mode to access the server’s operating system disk
to fix a corrupted file system, reset access credentials on the
server, and do other emergency recovery tasks.


## Prerequisites

You need to have previously [created a server](new-server.md) that you
now wish to rescue. Additionally, if you prefer to work with the
OpenStack CLI, then make sure to properly [enable it
first](../../getting-started/enable-openstack-cli.md).


## Initiating the rescue

=== "{{gui}}"
    Navigate to the server list.

    ![The left hand side navigation panel, with the word "Servers"
    highlighted.](assets/rescue-server/01-left-side-panel.png)

    Find the server you want to rescue in the list, and on the
    right-hand side, click on its menu button.

    ![An orange circle with three white
    dots.](assets/rescue-server/02-menu-button.png)

    Click on _Rescue Server_.

    ![A list of server actions, with the line "Rescue Server"
    highlighted.](assets/rescue-server/03-menu-list.png)

    Once selected, the rescue dialog appears.
    Leave the default option, _Use System Rescue Image_.

    Click _No_ to cancel or _Rescue_ to proceed.

    ![About to rescue a server, showing details with the default option
    "Use System Rescue Image".](assets/rescue-server/04-rescue-button.png)

    When a server has been switched to rescue mode, its status icon
    appears with an exclamation mark:

    ![Exclamation mark on server icon showing the server on "rescue
    mode".](assets/rescue-server/05-rescue-mode.png)

=== "OpenStack CLI"
    You must first select a system rescue image from the available
    images:

    ```console
    $ openstack image list --tag system-rescue
    +--------------------------------------+---------------+--------+
    | ID                                   | Name          | Status |
    +--------------------------------------+---------------+--------+
    | cb2217f3-1ca7-4440-b10e-df7ff2d92cae | system-rescue | active |
    +--------------------------------------+---------------+--------+
    ```

    To start the server using the system rescue image, use the
    following command, substituting the correct ID for the
    `system-rescue` image in your {{brand}} region:

    ```bash
    openstack --os-compute-api-version 2.87 \
      server rescue \
      --image cb2217f3-1ca7-4440-b10e-df7ff2d92cae <server_id>
    ```

    While the rescue is ongoing, the server should have the
    `OS-EXT-STS:vm_state` of `rescued` and the `status` of
    `RESCUE`.

    ```console
    $ openstack server show -v OS-EXT-STS:vm_state -c status <server_id>
    +---------------------+---------+
    | Field               | Value   |
    +---------------------+---------+
    | OS-EXT-STS:vm_state | rescued |
    | status              | RESCUE  |
    +---------------------+---------+
    ```

## Accessing the server in rescue mode

You can now proceed to accessing the remote console of your server,
[as you would with any other newly launched
server](new-server.md#connecting-to-the-server-console).

Please refer to the [System Rescue
documentation](https://www.system-rescue.org/manual/) documentation
for details on the available tools and features bundled with System
Rescue.
