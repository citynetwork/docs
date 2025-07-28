---
description: You can use the Swift API to configure a container with public read access, so that anyone can download its objects with a web browser.
---
# Working with a public Swift container

## Prerequisites

In order to create a Swift container, be sure that you have [installed and configured](index.md) the required command-line interface (CLI) tools.


## Creating the container

To create a public container (that is, one whose contents can be accessed without credentials), use the following command:

=== "OpenStack CLI"
    ```console
    $ openstack container create --public public-container
    +---------------------------------------+------------------+------------------------------------------------+
    | account                               | container        | x-trans-id                                     |
    +---------------------------------------+------------------+------------------------------------------------+
    | AUTH_d42230ea21674515ab9197af89fa5192 | public-container | tx00000e577d32d25b6cf84-0067c01964-11148d9-az1 |
    +---------------------------------------+------------------+------------------------------------------------+
    ```
=== "Swift CLI"
    ```console
    $ swift post --read-acl ".r:*,.rlistings" public-container
    ```
    This command produces no output.


## Retrieving container information

To create a list of all containers accessible with your current set of credentials, use this command:

=== "OpenStack CLI"
    ```console
    $ openstack container list
    +-------------------+
    | Name              |
    +-------------------+
    | private-container |
    | public-container  |
    +-------------------+
    ```
=== "Swift CLI"
    ```console
    $ swift list
    private-container
    public-container
    ```

To retrieve more detailed information about an individual container, you can also use this command.
Observe that the Read access control list (ACL) contains the entry `.r:*,.rlistings`, which enables read access to all objects in a container, and to a list of objects included in the container.

=== "OpenStack CLI"
    ```console
    openstack container show public-container
    +----------------+---------------------------------------+
    | Field          | Value                                 |
    +----------------+---------------------------------------+
    | account        | AUTH_d42230ea21674515ab9197af89fa5192 |
    | bytes_used     | 0                                     |
    | container      | public-container                      |
    | object_count   | 0                                     |
    | read_acl       | .r:*,.rlistings                       |
    | storage_policy | default-placement                     |
    +----------------+---------------------------------------+
    ```
=== "Swift CLI"
    ```console
    $ swift stat public-container
                          Account: AUTH_d42230ea21674515ab9197af89fa5192
                        Container: public-container
                          Objects: 1
                            Bytes: 12
                         Read ACL: .r:*,.rlistings
                        Write ACL:
                       Sync To:
                         Sync Key:
                      X-Timestamp: 1740642660.27611
    X-Container-Bytes-Used-Actual: 4096
                 X-Storage-Policy: default-placement
                  X-Storage-Class: STANDARD
                    Last-Modified: Thu, 27 Feb 2025 08:53:38 GMT
                       X-Trans-Id: tx00000968578224f10c769-0067c0282d-1130eb5-az1
           X-Openstack-Request-Id: tx00000968578224f10c769-0067c0282d-1130eb5-az1
                    Accept-Ranges: bytes
                     Content-Type: text/plain; charset=utf-8
                       Connection: close
    ```

## Uploading data

To upload an object into the container, create a local test file:

```bash
echo "hello world" > testobj.txt
```

Then, upload the file (as a Swift object) into your container, and read back its metadata:

=== "OpenStack CLI"
    ```console
    $ openstack object create public-container testobj.txt
    +-------------+------------------+----------------------------------+
    | object      | container        | etag                             |
    +-------------+------------------+----------------------------------+
    | testobj.txt | public-container | 6f5902ac237024bdd0c176cb93063dc4 |
    +-------------+------------------+----------------------------------+

    $ openstack object show public-container testobj.txt
    +----------------+---------------------------------------+
    | Field          | Value                                 |
    +----------------+---------------------------------------+
    | account        | AUTH_d42230ea21674515ab9197af89fa5192 |
    | container      | public-container                      |
    | content-length | 12                                    |
    | content-type   | text/plain                            |
    | etag           | 6f5902ac237024bdd0c176cb93063dc4      |
    | last-modified  | Thu, 27 Feb 2025 07:55:16 GMT         |
    | object         | testobj.txt                           |
    +----------------+---------------------------------------+
    ```
=== "Swift CLI"
    ```console
    $ swift upload public-container testobj.txt
    testobj.txt

    $ swift stat public-container testobj.txt
                   Account: AUTH_d42230ea21674515ab9197af89fa5192
                 Container: public-container
                    Object: testobj.txt
              Content Type: text/plain
            Content Length: 12
             Last Modified: Thu, 27 Feb 2025 08:56:20 GMT
                      ETag: 6f5902ac237024bdd0c176cb93063dc4
                Meta Mtime: 1740646531.753365
             Accept-Ranges: bytes
               X-Timestamp: 1740646580.91169
                X-Trans-Id: tx00000f18c8e00bf4f5931-0067c028cb-11148d9-az1
    X-Openstack-Request-Id: tx00000f18c8e00bf4f5931-0067c028cb-11148d9-az1
                Connection: close
    ```

## Downloading data

To download an object from your public Swift container, you can use the following commands (as with a private container):

=== "OpenStack CLI"
    ```console
    $ openstack object save --file - public-container testobj.txt
    hello world
    ```
    The `--file -` option prints the file contents to stdout.
    If instead you want to save the object's content to a local file, use `--file <filename>`.

    If you omit the `--file` argument altogether, `openstack object save` will create a local file named like the object you are downloading (in this case, `testobj.txt`).
=== "Swift CLI"
    ```console
    $ swift download -o - public-container testobj.txt
    hello world
    ```
    The `-o -` option prints the file contents to stdout.
    If instead you want to save the object's content to a local file, use `-o <filename>`.

    If you omit the `-o` argument altogether, `swift download` will create a local file named like the object you are downloading (in this case, `testobj.txt`).

However, this being a public container, you can *also* retrieve your object using any regular HTTP/HTTPS client, using a public URL.
This URL is composed as follows:

1. The Swift API's base URL, which differs by {{brand}} region (`https://object-store.sto-com.{{brand_domain}}/swift/v1/`),
2. the container's account string, starting with `AUTH_`,
3. the container name (in our example, `public-container`),
4. the object name (in our example, `testobj.txt`).

Rather than composing the public URL manually, you can also retrieve it by parsing the CLI's debug output:

=== "OpenStack CLI"
    ```console
    $ openstack object show --debug public-container testobj.txt 2>&1 \
      | grep -o "https://.*testobj.txt"

    https://object-store.sto-com.{{brand_domain}}/swift/v1/AUTH_d42230ea21674515ab9197af89fa5192/public-container/testobj.txt
    https://object-store.sto-com.{{brand_domain}}:443 "HEAD /swift/v1/AUTH_d42230ea21674515ab9197af89fa5192/public-container/testobj.txt
    https://object-store.sto-com.{{brand_domain}}/swift/v1/AUTH_d42230ea21674515ab9197af89fa5192/public-container/testobj.txt
    ```
=== "Swift CLI"
    ```console
    $ swift stat --debug public-container testobj.txt 2>&1 \
      | grep -o "https://.*testobj.txt"
    https://object-store.sto-com.{{brand_domain}}:443 "HEAD /swift/v1/AUTH_d42230ea21674515ab9197af89fa5192/public-container/testobj.txt
    https://object-store.sto-com.{{brand_domain}}/swift/v1/AUTH_d42230ea21674515ab9197af89fa5192/public-container/testobj.txt
    ```

Once you have retrieved your public URL, you can fetch the object's contents using the client of your choice.
This example uses `curl`:

```console
$ curl https://object-store.sto-com.{{brand_domain}}/swift/v1/AUTH_d42230ea21674515ab9197af89fa51ntainer/testobj.txt
hello world
```
