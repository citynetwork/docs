---
description: Images provide an operating system for your server.
---

# Images

Public [Glance images](../../howto/openstack/glance/index.md) in {{brand}} contain regularly updated minimal versions of server operating systems.

These images also contain the [cloud-init](https://cloudinit.readthedocs.io) package applicable to the operating system, to support the injection of SSH public keys and other user data.

## Naming conventions

### Image names

Image names in {{brand}} follow a convention, which can be summarized as `${NAME} ${VERSION_ID} ${CODENAME} ${ARCH}`:

* `NAME`: Operating system name, such as `Ubuntu`, `Debian`, `Rocky`, etc.
* `VERSION_ID`: Operating system version, as in `22.04`, `11`, `9`, etc.
* `CODENAME`: Operating system codename, if present, like `Jammy Jellyfish`, `Bullseye`, etc.
   Modified codenames may reflect that some images serve special purposes, such as vGPU support.
   See below for details.
* `ARCH`: Platform architecture for which the operating system was built, for example: `x86_64`, `aarch64`, etc.

### Special codenames

* `NVGRID`: Images with `NVGRID` in the codename include pre-installed Nvidia GRID drivers and license files.
  These images allow you to use [CUDA](https://en.wikipedia.org/wiki/CUDA), and enable other computational features of vGPUs.
  You should use these images together with [flavors](../flavors/index.md) using the `g` [compute tier](../flavors/index.md#Compute_tiers).

## Tags and properties

Each public image is assigned a specific set of tags and properties.
You can use these tags to [filter and list](../../howto/openstack/glance/filter.md) images based on certain conditions.

### Tags

All public images available in {{brand}} support the following image tags:

* `os:${NAME}`: a short identifier for the operating system, such as `os:ubuntu`, `os:debian`, `os:rocky`, etc.
* `os_version:${VERSION_ID}`: the operating system version, such as `os_version:22.04`, `os_version:11`, `os_version:9`, etc.

### Properties

All public images available in {{brand}} support the following image properties:

* `architecture=${ARCH}`: Platform architecture, such as `architecture=x86_64`
* `os_distro=${NAME}`: distribution name, such as `os_distro=ubuntu`
* `os_version=${VERSION_ID}`: operating system version, such as `os_version=22.04`

[Other properties](https://docs.openstack.org/glance/latest/admin/useful-image-properties.html) may also be set on individual images.
For instance, the `image_original_user` property reflects the username of the default non-root user of the corresponding operating system -- and that piece of information may come in handy in various automation scenarios.
So, to find out the username of the default non-root user in the `Ubuntu 22.04 Jammy Jellyfish x86_64` image, you can type the following:

```console
$ openstack image show -f json "Ubuntu 22.04 Jammy Jellyfish x86_64" \
    | jq '.properties.image_original_user'
"ubuntu"
```

## Image updates and automation

Images in {{brand}} are updated regularly, and that is something you can deduce from the `replace_frequency` property.
See, for example, the value of this property in the `Ubuntu 22.04 Jammy Jellyfish x86_64` image:

```console
$ openstack image show -f json "Ubuntu 22.04 Jammy Jellyfish x86_64" \
    | jq '.properties.replace_frequency'
"monthly"
```

Per [the SCS reference](https://docs.scs.community/standards/scs-0102-v1-image-metadata/#image-updating), `monthly` here means that the image is replaced *at least once* per month.
Newer images have operating systems with all the latest package updates and security fixes.
Whenever a fresh version of an image is produced and made available, it has the exact same name as the previous version but a *different* UUID.
That is why in Ansible Playbooks, Heat templates, Terraform configurations, or your automation in general, you should refrain from using UUIDs and refer to images by name instead.
