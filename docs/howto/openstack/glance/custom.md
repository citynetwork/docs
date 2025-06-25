# Managing custom images

You can use the `openstack` CLI to upload a custom image to any of the regions you have access to.
In addition to that, you can create an image from a server's boot volume.

> Whenever possible, you should use the [supported base images](../../../reference/images/index.md) instead of creating your own.

## Uploading a custom image

To upload a custom image, use `openstack` like so:

```plain
openstack image create --disk-format <format> --file <local-filename> <image-name>
```

For instance, see how to upload a Debian 13 cloud image, which you can subsequently use to create cloud servers in {{brand}}:

```console
$ openstack image create \
    --disk-format qcow2 \
    --file debian-13-genericcloud-amd64-daily-20250623-2152.qcow2 \
    debian-13-daily

+------------------+-------------------------------------------------------------------------------+
| Field            | Value                                                                         |
+------------------+-------------------------------------------------------------------------------+
| checksum         | 5d073d57c0b89afa3a7a3352a42fd073                                              |
| container_format | bare                                                                          |
| created_at       | 2025-06-23T15:32:37Z                                                          |
| disk_format      | qcow2                                                                         |
| file             | /v2/images/b8e875da-cf0a-4732-ac12-5aad29adc2c0/file                          |
| id               | b8e875da-cf0a-4732-ac12-5aad29adc2c0                                          |
| min_disk         | 0                                                                             |
| min_ram          | 0                                                                             |
| name             | debian-13-daily-20250623-2152                                                 |
| owner            | dfc700467396428bacba4376e72cc3e9                                              |
| properties       | direct_url='rbd://2ae305d1-6742-4b1c-af69-825a3bae8b53/images/b8e875da-       |
|                  | cf0a-4732-ac12-5aad29adc2c0/snap', locations='[{'url':                        |
|                  | 'rbd://2ae305d1-6742-4b1c-af69-825a3bae8b53/images/b8e875da-                  |
|                  | cf0a-4732-ac12-5aad29adc2c0/snap', 'metadata': {'store': 'rbd'}}]',           |
|                  | os_hash_algo='sha512', os_hash_value='8f7c42267ca2b592f5d0b4d2155951e4cbc33be |
|                  | 0c9e64063a986424b123ac15acfba33c93a14211ba2071f5a18601de6665f7dae6e989fec8578 |
|                  | f1f1a800d06f', os_hidden='False',                                             |
|                  | owner_specified.openstack.md5='5d073d57c0b89afa3a7a3352a42fd073',             |
|                  | owner_specified.openstack.object='images/debian-13-daily-20250623-2152', owne |
|                  | r_specified.openstack.sha256='440c4c8be83225f855de5a91e009b2c3257bfb84beb9550 |
|                  | 7c5beffeeaaa59a32', self='/v2/images/b8e875da-cf0a-4732-ac12-5aad29adc2c0',   |
|                  | stores='rbd'                                                                  |
| protected        | False                                                                         |
| schema           | /v2/schemas/image                                                             |
| size             | 337444864                                                                     |
| status           | active                                                                        |
| tags             |                                                                               |
| updated_at       | 2025-06-23T15:36:54Z                                                          |
| virtual_size     | 3221225472                                                                    |
| visibility       | shared                                                                        |
+------------------+-------------------------------------------------------------------------------+
```

You may also set properties like `os_type`, `os_distro`, and `os_admin_user`, so it becomes easier to filter through your list of custom images:

```console
$ openstack image create \
    --disk-format qcow2 \
    --property os_type=linux \
    --property os_distro=freebsd \
    --property os_admin_user=freebsd \
    --file freebsd-14.2-ufs-2024-12-08.qcow2 \
    freebsd-14.2-ufs
```

Please keep in mind that although the uploaded disk image is in the `qcow2` format, whenever you create a boot volume from it, that volume will be in the `raw` format.

## Creating an image from a boot volume

You can create an image from an existing server's boot volume.
Let's assume you have a server named `app-srv`, which you have customized to your liking with the applications you want.
The server has one boot volume, and you need to know its ID:

```console
$ openstack server show -c volumes_attached -f value app-srv
id='a90787d6-00e0-4ad2-b923-5e4659736b27'
```

To create an image from the boot volume, you first have to delete the parent server.

> Before you delete the parent server, you should be sure that during its creation, its boot server was __not__ configured for automatic deletion in the event of server deletion.

You can now create that image:

```console
$ openstack image create \
    --volume a90787d6-00e0-4ad2-b923-5e4659736b27 \
    app-srv-img

+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+
| container_format    | bare                                 |
| disk_format         | raw                                  |
| display_description |                                      |
| id                  | a90787d6-00e0-4ad2-b923-5e4659736b27 |
| image_id            | 2d842eea-f523-4ffc-9407-20de439dd4ed |
| image_name          | app-srv-img                          |
| protected           | False                                |
| size                | 16                                   |
| status              | uploading                            |
| updated_at          | 2025-06-24T13:14:34.000000           |
| visibility          | shared                               |
| volume_type         | cbs                                  |
+---------------------+--------------------------------------+
```

You may check the progress of the whole process using the `openstack image show` command:

```console
$ openstack image show -c status app-srv-img

+--------+--------+
| Field  | Value  |
+--------+--------+
| status | saving |
+--------+--------+
```

When the image creation is complete, its status will be `active`:

```console
$ openstack image show -c status app-srv-img

+--------+--------+
| Field  | Value  |
+--------+--------+
| status | active |
+--------+--------+
```

