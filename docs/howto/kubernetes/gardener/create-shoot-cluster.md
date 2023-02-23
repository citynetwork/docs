---
description: How to spin up a Kubernetes cluster with Gardener
---
# Creating Kubernetes clusters

If you want to create a Kubernetes cluster, you can do so via the {{gui}} using {{k8s_management_service}}.
This guide shows you how to do that, and how to deploy a sample application on such a cluster.

## Prerequisites

* If this is your first time using {{k8s_management_service}} in {{brand}}, you need to [activate the service](index.md) from the {{gui}}.
* To access the Kubernetes cluster from your computer, you will need to [install `kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) on your machine.

## Creating a Kubernetes cluster in {{gui}}

To get started, navigate to <https://{{gui_domain}}>, and in the side panel choose *Containers → [{{k8s_management_service}}](https://{{gui_domain}}/containers/gardener)*.
You will see a {{k8s_management_service}} page, in which you can create and manage your clusters. Click *Create Kubernetes cluster*.

![{{k8s_management_service}} page in {{gui}}](assets/gardener_page.png)

In {{k8s_management_service}} terminology, a Kubernetes cluster is referred as a **Shoot** (as in, [new plant growth](https://en.wikipedia.org/wiki/Shoot)).

In the opened form, fill in the name of the new shoot cluster and select a region to see the rest of the options.

!["Create {{k8s_management_service}} Shoot Cluster" panel showing options to set a cluster name and region, and select a Kubernetes version](assets/create-shoot-1.png)

In the *Worker Groups* section, create at least one worker group.
Pay attention to the values you set for the following values:

* *Machine Type:* The [flavor](../../../reference/flavors/index.md) your worker nodes will use; this determines the number of CPU cores and RAM allocated to them.
* *Volume Size:* The amount of local storage allocated to each worker node.
* *Autoscaler Min:* The minimum number of worker nodes to run in the cluster at any time.
* *Autoscaler Max:* The maximum number of worker nodes the cluster automatically scales to, in the event that the current number of nodes cannot handle the deployed workload.
* *Max Surge:* The maximum number of additional nodes to deploy in an autoscaling event.

!["Create {{k8s_management_service}} Shoot Cluster" panel](assets/create-shoot-2.png)

For a test cluster, you can leave all values at their defaults, and click *Create* at the bottom.

!["Create {{k8s_management_service}} Shoot Cluster" panel](assets/create-shoot-3.png)

In the list of clusters, you will see your new {{k8s_management_service}} shoot bootstrapping.
The icon on the left marks the progress.
Creating the cluster can take several minutes.

![Shoot cluster bootstrapping](assets/shoot_bootstrapping.png)

### A note on quotas

Your Gardener worker nodes are subject to [quotas](../../../reference/quotas/openstack.md) applicable to your {{brand}} project.
You should make sure that considering your selection of worker node [*flavor*](../../../reference/flavors/index.md) (which determines the number of virtual cores and virtual RAM allocated to each node), the _volume size_, and the _Autoscaler Max_ value, you are not at risk of violating any quota.

For example, if your project is configured with the [default quotas](../../../reference/quotas/openstack.md), and you select the `b.4c16gb` flavor for your worker nodes, your cluster would be able to run with a maximum of 3 worker nodes (since their total memory footprint would be 3×16=48 GiB, just short of the default 50 GiB limit).
A 4th node would push your total memory allocation to 64 GiB, violating your quota.

If necessary, be sure to request a quota increase via our [{{support}}](https://{{support_domain}}).

## Extracting the kubeconfig file

When the Shoot cluster is up and running, you need to create a [kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) file to be able to access it.
To do that, click on the cluster to expand its properties, and open *KubeConfig*.

![KubeConfig tab in {{k8s_management_service}} Shoot view](assets/shoot_kubeconfig.png)

Copy the content of the kubeconfig using the *Copy Config* button, and insert it into `~/.kube/config`.
Create the directory and the file if needed.

> By default, `kubectl` searches for its configuration in `~/.kube/config`, but you can [modify this behavior](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) if needed.

Check if your `kubectl` uses the proper configuration by running:

```shell
kubectl config view
```

You should see something like this:

```yaml
apiVersion: v1
clusters:
  - cluster:
      certificate-authority-data: DATA+OMITTED
      server: https://api.test-cluster.p40698.staging-k8s.{{gui_domain}}
    name: shoot--p40698--test-cluster
contexts:
  - context:
      cluster: shoot--p40698--test-cluster
      user: shoot--p40698--test-cluster-token
    name: shoot--p40698--test-cluster
current-context: shoot--p40698--test-cluster
kind: Config
preferences: { }
users:
  - name: shoot--p40698--test-cluster-token
    user:
      token: REDACTED
```

## Accessing your cluster with `kubectl`

Check your available nodes by running:

```shell
kubectl get nodes
```

Assuming you used the default options when creating the cluster, you should now see the one {{k8s_management_service}} worker node that is initially available:

```console
NAME                                                STATUS   ROLES    AGE    VERSION
shoot--p40698--test-cluster-czg4zf-z1-5d7b5-bfl7p   Ready    <none>   156m   v1.24.3
```

> Please note that in contrast to an [OpenStack Magnum-managed Kubernetes cluster](../../../openstack/magnum/new-k8s-cluster) (where the output of `kubectl get nodes` includes control plane and worker nodes), in a {{k8s_management_service}} cluster the same command *only* lists the worker nodes.


## Deploying an application

Create a sample deployment with a Hello World application:

```shell
kubectl create deployment hello-node --image=registry.k8s.io/echoserver:1.4
kubectl expose deployment hello-node --type=LoadBalancer --port=8080
```

To access the created app, list the available services:

```shell
kubectl get services
```

You should get the load balancer service with its external IP and port
number:

```console
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)          AGE
hello-node   LoadBalancer   100.69.16.106   198.51.100.42   8080:32039/TCP   34m
kubernetes   ClusterIP      100.64.0.1      <none>          443/TCP          3h46m
```

Open a browser to `http://198.51.100.42:8080` (substituting the correct `EXTERNAL-IP` listed for your service).
You should see the page of the Hello World app.
