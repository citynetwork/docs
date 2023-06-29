---
description: Images provide an Operating System for your server.
---

# Images

Any server instance running in {{brand}} is created either from an image
or from a volume. Images built by {{brand}} are publicly available and
contain latest minimal versions of Operating Systems. These images also contain
**cloud-init** package to support the SSH key pair and user data injection.

> Please note, that images provided by {{brand}} are rotated periodically, so
never reference image UUID directly in your tooling and always use image names or
search for image UUIDs when required.

You can also upload custom images to {{brand}} and utilize them instead of
the provided public ones.

## Naming conventions

### Image names

Image names in {{brand}} follow a convention, which can be summarized as
`${NAME} ${VERSION_ID} ${CODENAME} ${ARCH}`:

* `NAME`: Operating System name, for example `Ubuntu`, `Debian`, `Rocky`,
  etc.
* `VERSION_ID`: Operating System version, for example: `22.04`, `11`, `9`,
  etc.
* `CODENAME`: Operating System codename, if present, for example:
    `Jammy Jellyfish`, `Bullseye`, etc. In case it's specially prepared image,
    for example containing GPU drivers and license, OS CODENAME can be
    substituted with such special codenames, that are described below.
* `ARCH`: Platform architechture, for which Operating System was built, for
    example: `x86_64`, `aarch64`, etc.

### Special codenames

Following special `CODENAME` are available at the moment:
* `NVGRID`: Images with such codename does have pre-installed Nvidia GRID
  drivers and license files, that allows to utilize CUDA and other    computational features of GPUs. You should use such images with `g`
  [compute tier](../flavors/#Compute_tiers)

### Tags and properties

Each public image is assigned a specific set of tags and properties, that
identifies the image and allows to perform filtering based on them.


#### Tags

At the moment tags that follow naming convetion below are applied to all public
images produced by {{brand}}:

* `os:${NAME}`: Operating System name, example tags: `os:ubuntu`,
  `os:debian`, `os:rocky`, etc.
* `os_version:${VERSION_ID}`: Operating System version, example tags:
  `os_version:22.04`, `os_version:11`, `os_version:9`, etc.

#### Properties

At the moment properties that follow naming convention below are applied to all
public images produced by {{brand}}:

* `architecture=${ARCH}`: Platform architechture, example:
  `architecture=x86_64`
* `os_distro=${NAME}`: Operating System name, example: `os_distro=ubuntu`
* `os_version=${VERSION_ID}`:  Operating System version, example:
  `os_version=22.04`

## Filtering images

In order to navigate among all images produced by {{brand}} easily, we provide
a guidance on how to find required image easily through CLI or {{gui}}.

=== "OpenStack CLI"

    In CLI you can have 2 way of filtering images: by image tags or by image
    properties.

    **Filter by properties**

    You can also apply filtering of available images based on the image
    properties using following command:

    ```bash
    openstack image list --status active --property os_distro=ubuntu --property os_version=20.04
    ```

    ```plain
    +--------------------------------------+---------------------------------+--------+
    | ID                                   | Name                            | Status |
    +--------------------------------------+---------------------------------+--------+
    | f0babf5c-65b6-40d7-b5ce-e60361f2cb09 | Ubuntu 20.04 Focal Fossa x86_64 | active |
    +--------------------------------------+---------------------------------+--------+
    ```

    > You can specify multiple tags to narrow down your request even more. Though
    you **can not** use tags **as negative** filters, for example selecting all
    Ubuntu, except 20.04 is not possible.


    **Filter by tags**

    In order to list images that match specific tag only you can use the
    following command:

    ```bash
    openstack image list --status active --tag os:ubuntu --tag os_version:20.04
    ```

    ```plain
    +--------------------------------------+---------------------------------+--------+
    | ID                                   | Name                            | Status |
    +--------------------------------------+---------------------------------+--------+
    | f0babf5c-65b6-40d7-b5ce-e60361f2cb09 | Ubuntu 20.04 Focal Fossa x86_64 | active |
    +--------------------------------------+---------------------------------+--------+
    ```

    > You can specify multiple tags to narrow down your request even more. Though
    you **can not** use tags **as negative** filters, for example selecting all
    Ubuntu, except 20.04 is not possible.


    **Filter by name**

    Since we aim to make image names consistent, you can also apply filtering based
    on image names. For example:

    ```bash
    openstack image list --status active --name "Ubuntu 20.04 Focal Fossa x86_64"
    ```

    ```plain
    +--------------------------------------+---------------------------------+--------+
    | ID                                   | Name                            | Status |
    +--------------------------------------+---------------------------------+--------+
    | f0babf5c-65b6-40d7-b5ce-e60361f2cb09 | Ubuntu 20.04 Focal Fossa x86_64 | active |
    +--------------------------------------+---------------------------------+--------+
    ```

    > Please note, that filtering by image names might not be interoperable between
    different cloud providers. Filtering by properties is adviced for
    interoperability

=== "{{gui}}"

    **When creating a server**

    Images are sorted by their Operating System on the `Create a Server`
    menu.

    ![A panel displaying the images sorted by operating system during server
    creation.](assets/image-folders-create-server.png)

    ![A panel displaying Rocky images when user descends to rocky folder on
    create a server screen.](assets/image-rocky-list-create-server.png)

    **On the Images tab**

    You can also see full list of images in Images -> Public Images menu.
    However, you can only filter by the image name on this page. No other
    filtering or sorting is available at the moment.

    ![A public images panel that uses filtering of images by name to show all
    Rocky images in all regions.](assets/image-rocky-list-public-images.png)
