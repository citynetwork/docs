# Working with a private Swift container

## Prerequisites

In order to create a Swift container, be sure that you have
[installed and configured](index.md) the required command-line interface
(CLI) tools.


## Creating a private container

To create a private container (that is, one that can only be accessed
with proper Swift API credentials), use the following command:

=== "OpenStack CLI"
    ```console
    $ openstack container create private-container
    +---------------------------------------+-------------------+----------------------------------------------------+
    | account                               | container         | x-trans-id                                         |
    +---------------------------------------+-------------------+----------------------------------------------------+
    | AUTH_30a7768a0ffc40359d6110f21a6e7d88 | private-container | tx00000ddb0f9e2a50ad881-00638dbf9c-300de11-default |
    +---------------------------------------+-------------------+----------------------------------------------------+
    ```
=== "Swift CLI"
    ```bash
    swift post private-container
    ```
    This command produces no output.


## Retrieving container information

To create a list of all containers accessible with your current set of
credentials, use this command:

=== "OpenStack CLI"
    ```console
    $ openstack container list
    +-------------------+
    | Name              |
    +-------------------+
    | private-container |
    +-------------------+
    ```
=== "Swift CLI"
    ```console
    $ swift list
    private-container
    ```

To retrieve more detailed information about an individual container,
you can also use this command:

=== "OpenStack CLI"
    ```console
    $ openstack container show private-container
    +----------------+---------------------------------------+
    | Field          | Value                                 |
    +----------------+---------------------------------------+
    | account        | AUTH_30a7768a0ffc40359d6110f21a6e7d88 |
    | bytes_used     | 0                                     |
    | container      | private-container                     |
    | object_count   | 0                                     |
    | storage_policy | default-placement                     |
    +----------------+---------------------------------------+
    ```
=== "Swift CLI"
    ```console
    $ swift stat private-container
                          Account: AUTH_30a7768a0ffc40359d6110f21a6e7d88
                        Container: private-container
                          Objects: 0
                            Bytes: 0
                         Read ACL:
                        Write ACL:
                          Sync To:
                         Sync Key:
                      X-Timestamp: 1670234012.31534
    X-Container-Bytes-Used-Actual: 0
                 X-Storage-Policy: default-placement
                  X-Storage-Class: STANDARD
                    Last-Modified: Mon, 05 Dec 2022 09:53:32 GMT
                       X-Trans-Id: tx0000073eebb42acd6e7e1-00638dbfe8-301ddeb-default
           X-Openstack-Request-Id: tx0000073eebb42acd6e7e1-00638dbfe8-301ddeb-default
                    Accept-Ranges: bytes
                     Content-Type: text/plain; charset=utf-8
    ```

## Uploading data

To upload an object into the container, create a local test file:

```bash
echo "hello world" > testobj.txt
```

Then, upload the file (as a Swift object) into your container, and
read back its metadata:

=== "OpenStack CLI"
    ```console
    $ openstack object create private-container testobj.txt
    +-------------+-------------------+----------------------------------+
    | object      | container         | etag                             |
    +-------------+-------------------+----------------------------------+
    | testobj.txt | private-container | 6f5902ac237024bdd0c176cb93063dc4 |
    +-------------+-------------------+----------------------------------+

    $ openstack object show private-container testobj.txt
    +----------------+---------------------------------------+
    | Field          | Value                                 |
    +----------------+---------------------------------------+
    | account        | AUTH_30a7768a0ffc40359d6110f21a6e7d88 |
    | container      | private-container                     |
    | content-length | 12                                    |
    | content-type   | text/plain                            |
    | etag           | 6f5902ac237024bdd0c176cb93063dc4      |
    | last-modified  | Mon, 05 Dec 2022 10:00:34 GMT         |
    | object         | testobj.txt                           |
    | properties     | mtime='1670234292.370177'             |
    +----------------+---------------------------------------+
    ```
=== "Swift CLI"
    ```console
    $ swift upload private-container testobj.txt
    testobj.txt

    $ swift stat private-container testobj.txt
                   Account: AUTH_30a7768a0ffc40359d6110f21a6e7d88
                 Container: private-container
                    Object: testobj.txt
              Content Type: text/plain
            Content Length: 12
             Last Modified: Mon, 05 Dec 2022 10:00:34 GMT
                      ETag: 6f5902ac237024bdd0c176cb93063dc4
                Meta Mtime: 1670234292.370177
             Accept-Ranges: bytes
               X-Timestamp: 1670234434.67877
                X-Trans-Id: tx000000f26ccf73c19f596-00638dc160-300de11-default
    X-Openstack-Request-Id: tx000000f26ccf73c19f596-00638dc160-300de11-default
    ```

## Downloading data

To download an object from your Swift container, use the following
command:

=== "OpenStack CLI"
    ```console
    $ openstack object save --file - private-container testobj.txt
    hello world
    ```
    The `--file -` option prints the file contents to stdout. If
    instead you want to save the object's content to a local file,
    use `--file <filename>`.

    If you omit the `--file` argument altogether, `openstack object
    save` will create a local file named like the object you are
    downloading (in this case, `testobj.txt`).
=== "Swift CLI"
    ```console
    $ swift download -o - private-container testobj.txt
    hello world
    ```
    The `-o -` option prints the file contents to stdout. If
    instead you want to save the object's content to a local file,
    use `-o <filename>`.

    If you omit the `-o` argument altogether, `swift download`
    will create a local file named like the object you are
    downloading (in this case, `testobj.txt`).
