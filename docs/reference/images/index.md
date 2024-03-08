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
* `ARCH`: Platform architecture for which the operating system was built, for example: `x86_64`, `aarch64`, etc.

## Tags and properties

Each public image is assigned a specific set of tags and properties.
You can use these tags to [filter and list](../../howto/openstack/glance/filter.md) images based on certain conditions.
You may also use them to simply [examine](../../howto/openstack/glance/examine.md) how an image is configured.

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
In particular, {{brand}} aims to set image properties according to the [metadata standard](https://docs.scs.community/standards/scs-0102-v1-image-metadata/) defined by the [Sovereign Cloud Stack](https://scs.community/) (SCS) initiative.

## Community images

At {{brand}}, we regularly update and rotate our images to always provide
secure public images.

During rotation, we change an image's visibility from `public` to `community`,
while keeping its image name. This enables tools like
[Heat](https://docs.openstack.org/heat/) or [Terraform](https://www.terraform.io/)
to pass validation checks without attempting to alter environments.

You can retrieve an image's original build date (for images with both
`public` and `community` visibility) by checking its `build_date` tag or
`image_build_date` property.

> Usage of community images is not recommended and is always upon
> full responsibility of the user.
