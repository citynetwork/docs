---
description: Gardener in Cleura Cloud runs its worker and control plane nodes on Garden Linux.
---
# Garden Linux

In a {{k8s_management_service}} cluster, worker nodes run [Garden Linux](https://gardenlinux.io), which is a [Linux distribution](https://en.wikipedia.org/wiki/Linux_distribution) based on [Debian GNU/Linux](https://www.debian.org/).

## Version scheme

Garden Linux uses an unusual version scheme: releases use a major version number that is derived from the "gardenlinux epoch", and should ostensibly reflect the number of days since April 1, 2020 (although in reality, the major release numbers are off by a number of days).

For example, the major release that landed on November 17, 2021 was release [576](https://github.com/gardenlinux/gardenlinux/releases/tag/576.0).
The next major release, on November 11, 2022, had the major release number [934](https://github.com/gardenlinux/gardenlinux/releases/tag/934.1).

Minor releases are numbered with incrementing integer minor version numbers.
They tend to include mostly bug fixes, as opposed to functionality updates or new features.
For example, [934.6](https://github.com/gardenlinux/gardenlinux/releases/tag/934.6) was a Garden Linux release that fixed several security issues in the 934 release series.

## Linux kernel

Garden Linux runs on the latest [longterm release](https://www.kernel.org/category/releases.html) Linux kernel version available at the time of a major release.
For example, Garden Linux 576 includes the Linux 5.10 kernel, whereas Garden Linux 934 includes Linux 5.15.

## Container runtime

Garden Linux defaults to using the [Podman](https://podman.io/) container runtime.
