---
description: Gardener runs its worker and control plane nodes on Garden Linux.
---
# Garden Linux

In a {{k8s_management_service}} cluster, worker nodes run [Garden Linux](https://gardenlinux.io), which is a [Linux distribution](https://en.wikipedia.org/wiki/Linux_distribution) based on [Debian GNU/Linux](https://www.debian.org/).

## Version scheme

Garden Linux uses an unusual version scheme: releases use a major version number derived from the "gardenlinux epoch", and should ostensibly reflect the number of days since April 1, 2020 (although in reality, the major release numbers are off by a number of days).

For example, the major release that landed on November 11, 2022 was release [934](https://github.com/gardenlinux/gardenlinux/releases/tag/934.1).
The next major release, on November 23, 2023, had the major release number [1312](https://github.com/gardenlinux/gardenlinux/releases/tag/1312.1).

Minor releases are numbered with incrementing integer minor version numbers.
They tend to include mostly bug fixes, as opposed to functionality updates or new features.
For example, [934.6](https://github.com/gardenlinux/gardenlinux/releases/tag/934.6) was a Garden Linux release that fixed several security issues in the 934 release series.

## Linux kernel

Garden Linux runs on the latest [longterm release](https://www.kernel.org/category/releases.html) Linux kernel version available at the time of a major release.
For example, Garden Linux 934 includes the Linux 5.15 kernel, whereas Garden Linux 1312 includes Linux 6.6.

## Container runtime

Garden Linux defaults to using the [Podman](https://podman.io/) container runtime.
