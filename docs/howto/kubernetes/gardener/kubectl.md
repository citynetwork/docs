---
description: How to fetch, verify, and use your kubeconfig with kubectl.
---
# Managing a Kubernetes cluster

## Extracting the kubeconfig file

Once you [have launched a new shoot cluster](create-shoot-cluster), you need to create a [kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) file to be able to access it.
To do that, click on the cluster to expand its properties, and open *KubeConfig*.

![KubeConfig tab in {{k8s_management_service}} Shoot view](assets/shoot_kubeconfig.png)

Click the blue button labeled *Download KubeConfig*. Almost
instantaneously, in the default download folder of your computer, you
will get a configuration file with a name similar to
`kubeconfig--<cluster_name>--<region_name>--<project_id>.yaml`. Create a
directory named `.kube` in your local user's home, then move the YAML
file you downloaded into it. Rename the YAML to `config`, ending up with
`~/.kube/config`.

> By default, `kubectl` searches for its configuration in
> `~/.kube/config`, but you can [modify this
> behavior](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/)
> by setting the `KUBECONFIG` environment variable, if needed. For
> example, if you want to retain the original filename as downloaded,
> you might use:
>
> ```bash
> export KUBECONFIG=~/.kube/kubeconfig--<cluster_name>--<region_name>--<project_id>.yaml
> ```
>
> You may prefer this approach if you manage multiple Kubernetes
> clusters.

## Verifying your kubeconfig

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

You will notice that the cluster API endpoint (the `server` entry in your kubeconfig) is a dynamically managed DNS address.
Gardener in {{brand}} automatically created the DNS record upon shoot cluster creation.

The DNS record will subsequently disappear when you delete the cluster.
The DNS record *also* disappears when you [hibernate the shoot cluster](hibernate-shoot-cluster.md), and reappears when you wake it from hibernation.

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
