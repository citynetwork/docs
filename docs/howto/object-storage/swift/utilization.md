---
description: A number of options exist to show object storage utilization.
---
# Object storage utilization

You may be interested in the number of objects, or their cumulative size, currently held in a container.


## Prerequisites

To examine a Swift container, be sure that you have [installed and configured](index.md) the required command-line interface (CLI) tools.


## Showing the number of objects in a container

To show the number of objects in a given container, use one of the following commands:

=== "OpenStack CLI"
    ```bash
    openstack container show <container> -c object_count
    ```
=== "Swift CLI"
    ```bash
    swift stat <container>
    ```
    The object count is in the line prefixed with `Objects`.


## Showing the total size of objects in a container

To show the overall size of all objects in a given container, use one of the following commands:

=== "OpenStack CLI"
    ```bash
    openstack container show <container> -c bytes_used
    ```
    The total object size is always given in bytes.
=== "Swift CLI"
    ```bash
    swift stat <container>
    ```
    The total object size is in the line prefixed with `Bytes`.

    To scale the total size output to human-readable units, add the `--lh` option:

    ```bash
    swift stat --lh <container>
    ```
