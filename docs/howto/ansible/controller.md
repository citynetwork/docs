# Deploy control node

Start by [creating a new server](/howto/openstack/nova/new-server/), a small size [Flavor](/reference/flavors) is fine to begin with.
As your automation and number of managed hosts grow, you can easily [resize](/howto/openstack/nova/resize-server/) your control node.

## Install

For a "batteries included" experience, install the `ansible` metapackage which comes with collections included.

=== "RHEL/CentOS"

    Ansible with collections:
    ```sh
    sudo dnf in -y epel-release && \
    sudo dnf in -y ansible
    ```

    Ansible-core only:
    ```sh
    sudo dnf in -y ansible-core
    ```

=== "Ubuntu"

    Ansible with collections:
    ``` sh
    sudo apt install -y ansible
    ```
    Ansible-core only:
    ``` sh
    sudo apt install -y ansible-core
    ```
