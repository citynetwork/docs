# Moving a server from one region to another

This guide will show you how to move or copy your server volume to a different region in {{brand}} Cloud.

## Prerequisites

- Installed [OpenStack CLI client](../../../getting-started/enable-openstack-cli/)
- Access to source and target location (RC-file)
- Enough space on the local machine that you download your server to
- Target location configured with Network, Security Groups etc

## Recommendations

Use the UUID of the server instead of using the server name. This will make sure that you are using the correct server.

To list the names matching UUIDs of your servers, use the following command:

```bash
openstack server list
```

To get the correct UUID of your server root volume you can use the following command:

```bash
openstack server show <uuid-of-server> -c volumes_attached
```

If there is multiple volumes attached usually the first volume is the root volume.

## Creating a image

When creating a image of an server you are recommended to shut down your server.

```bash
# Shutdown your server
openstack server stop <uuid-of-server>
```

To start the image process use the following command:

```bash
openstack image create --volume <uuid-of-root-volume> <new-image-name>
```

After a while you will get some output showing information of the new image, such as the current state and the image UUID.

Before going on the state needs to be active. To see the current state use the following command:

```bash
openstack image show <uuid>
```

## Download your image

Before you can download the image you need to know what format the image has. To find the image format run the following command:

```bash
openstack image show -f value -c disk_format <image_id>
```

To download the image to the local machine, use the following command:

```bash
openstack image save --file <local image name>.<disk_format> <your_image_id>
```

When you have downloaded the file, you are done with the steps for the source region. The following steps will be done on the target region.

## Target Location

Load the [rc-file](../../getting-started/enable-openstack-cli.md) for the target region.

```bash
source <target_openrc.sh>
```

## Upload your image

 Upload the file to the new location. Set the appropriate disk format, and select a name for the image.

```bash
openstack image create --disk-format <disk_format> --file snapshot.<disk_format> <new_image_name>
```

The upload will take some time. To check the status of the upload use the following command:

```bash
openstack image show <new_image_name>
```

When the image's `status` field returns `active`, the upload is done.

## Create a new server

Now you need to create a new server from the uploaded image. To create a new server follow this [guide](/new-server.md).

> If you using {{brand}} Cloud Management Panel choose boot from private image, instead of boot from image.
