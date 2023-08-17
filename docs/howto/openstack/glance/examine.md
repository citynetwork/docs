# Examining images

You can use the `openstack` CLI in combination with the [`jq`](https://jqlang.github.io/jq/) command-line JSON processor to inspect an image's properties.

## Default user

The `image_original_user` property reflects the username of the default non-root user of the corresponding operating system -- and that piece of information may come in handy in various automation scenarios.
So, to find out the username of the default non-root user in the `Ubuntu 22.04 Jammy Jellyfish x86_64` image, you can type the following:

```console
$ openstack image show -f json "Ubuntu 22.04 Jammy Jellyfish x86_64" \
    | jq '.properties.image_original_user'
"ubuntu"
```

## Image update frequency

Images in {{brand}} are updated regularly, and that is something you can deduce from the `replace_frequency` property.
See, for example, the value of this property in the `Ubuntu 22.04 Jammy Jellyfish x86_64` image:

```console
$ openstack image show -f json "Ubuntu 22.04 Jammy Jellyfish x86_64" \
    | jq '.properties.replace_frequency'
"monthly"
```

Per [the SCS reference](https://docs.scs.community/standards/scs-0102-v1-image-metadata/#image-updating), `monthly` here means that the image is replaced *at least once* per month.
Newer images have operating systems with all the latest package updates and security fixes.


## Image build date

To find out when a particular image was most recently updated, inspect its `image_build_date` property:

```console
$ openstack image show -f json "Ubuntu 22.04 Jammy Jellyfish x86_64" \
    | jq '.properties.image_build_date'
"2023-08-11"
```
