---
description: How to enable HA for the control plane or Worker Groups of a Gardener cluster
---
# Enabling high availability

When you [create a new {{k8s_management_service}} cluster](create-shoot-cluster.md), you have the option to enable high availability (HA) features for its control plane.
In case you have an existing {{k8s_management_service}} cluster with a non-HA control plane, you may at any time enable the HA features for that control plane.

> Keep in mind that once you enable HA for the control plane of a {{k8s_management_service}} cluster, you cannot disable it for that particular cluster.

Additionally, you may add HA characteristics to one or more Worker Groups of an existing cluster.

## Enabling HA for the control plane

Using your favorite web browser, navigate to <https://{{gui_domain}}> and log in.
In the left-hand side panel, choose *Containers → [{{k8s_management_service}}](https://{{gui_domain}}/containers/gardener)*.
Then, in the central pane of the {{gui}}, you see all of your {{k8s_management_service}} clusters, organized by {{brand}} region.

![Get the list of all available {{k8s_management_service}} clusters](assets/shoot-enable-ha-01.png)

Locate the cluster you are interested in, and click the orange :material-dots-horizontal-circle: icon on the right of the corresponding row.
From the drop-down menu that appears, select _Modify Cluster_.

![Select the option for modifying a cluster](assets/shoot-enable-ha-02.png)

A vertical pane titled _Modify Gardener Shoot Cluster_ slides over from the right.
In it, you see the disabled option _Enable Highly Available Control Plane_.
Click on it to enable HA for the control plane of the shoot cluster.

![Notice the option for enabling control plane HA](assets/shoot-enable-ha-03.png)

Before the change is applied, a warning appears:
enabling HA is an irreversible action.
Once you take it, there is no way to disable HA at a later time.

![Select HA for the control plane](assets/shoot-enable-ha-04.png)

If you are sure you want to enable HA, scroll down a bit until you see the green _Update_ button and click on it.

![Activate HA for the control plane](assets/shoot-enable-ha-05.png)

Enabling HA for the control plane of any {{k8s_management_service}} cluster takes a few minutes.
You can see how the process is progressing by the animated icon on the left of the cluster row.

![HA for control plane is being prepared](assets/shoot-enable-ha-06.png)

As soon as HA is enabled, the animated icon changes into a check mark (:material-check-circle:).

![HA for control plane is now enabled](assets/shoot-enable-ha-07.png)

## Enabling HA for Worker Groups

You may add HA characteristics to one or more Worker Groups by modifying the _Autoscaler&nbsp;Min_ and _Autoscaler&nbsp;Max_ parameters.

First off, select the {{k8s_management_service}} cluster you are interested in.
Click on the cluster row to expand its characteristics, then select the _Worker Groups_ tab.

![View Worker Group details](assets/shoot-enable-ha-08.png)

Click once more on the :fontawesome-solid-pen-to-square: icon of the Worker Group you wish to modify.
A vertical pane named _Modify Worker Group_ slides over from the right.

![Modify Worker Group](assets/shoot-enable-ha-09.png)

Modify the _Autoscaler&nbsp;Min_ and _Autoscaler&nbsp;Max_ parameters.
You may, for instance, set _Autoscaler&nbsp;Min_ to 3 and _Autoscaler&nbsp;Max_ to 5.
When you are ready to apply the changes, click the green _Update_ button.

![Modify autoscaling parameters](assets/shoot-enable-ha-10.png)

After a few seconds, the new values for the autoscaler parameters will be visible in the _Worker Groups_ tab.

![View modified Worker Group](assets/shoot-enable-ha-11.png)

