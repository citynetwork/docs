---
description: How auto-upgrading works in Gardener-managed Kubernetes clusters
---
# Automatic upgrades

By default, Kubernetes clusters created with {{brand_container_orchestration}} are upgraded automatically.

More specifically, during the specified maintenance window, {{k8s_management_service}} checks for a new Kubernetes version, and a new version of the base image that runs on the control plane and worker nodes.
If there is a new version of any of those, the cluster starts upgrading automatically.

During the upgrade, the API server may briefly be unavailable.

## Machine image upgrades

Both minor and major [Garden Linux](garden-linux.md) release upgrades are allowed and performed automatically.
Also, version jumps are allowed over minor release upgrades.

Whenever there is a new machine image available, this is indicated in the {{gui}}:

![New machine image indicator](assets/gard_new_img_sign.png)

Before the auto-upgrade kicks in, the version of the new image is displayed in the expanded view of the cluster, in the *Worker Groups* tab.

![New machine image available](assets/gard_new_img_avail.png)

## Kubernetes upgrades

Due to the Kubernetes versioning scheme, which does not follow the [semantic versioning](https://en.wikipedia.org/wiki/Software_versioning#Semantic_versioning) logic, only patch-level release upgrades and jumps are performed automatically.
For instance, an upgrade from 1.24.9 to 1.24.10 is allowed, and so is an upgrade from 1.24.9 to 1.24.11.

Minor release upgrades, such as from 1.24 to 1.25, do not happen automatically.
You must always initiate them from the {{gui}}.

## Hibernated clusters

Whenever a {{k8s_management_service}} cluster is [hibernated](hibernation.md), all of its worker nodes are removed.

If automatic upgrades are enabled on a hibernated cluster, then waking the cluster will initiate an immediate automated upgrade.
That is to say that, rather than recreating them with the old versions and waiting for the next maintenance window, {{k8s_management_service}} recreates the worker nodes using current (updated) Garden Linux and Kubernetes versions.
