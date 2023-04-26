---
description: How to fetch, verify, and use your kubeconfig with kubectl in a Magnum-managed Kubernetes cluster.
---
# Managing a Kubernetes cluster

Once you [have launched a new cluster](new-k8s-cluster.md), you can interact with it using `kubectl` and a [kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) file.

## Prerequisites

You must install the Kubernetes command line tool, `kubectl`, on your local computer, and run commands against your cluster.
To install `kubectl`, follow [the relevant Kubernetes documentation](https://kubernetes.io/docs/tasks/tools/#kubectl).

## Extracting the kubeconfig file

Due to Magnum's security policy configuration, you cannot use the OpenStack CLI for downloading the kubeconfig of a cluster that was created with {{gui}}, or vice versa.

To fetch your kubeconfig, you must always use the same facility that you used to deploy the cluster.

=== "{{gui}}"
    In the left-hand side pane of the {{gui}}, select *Magnum* → *Clusters*.
    Click on the cluster row to expand the details view, then click the
    *KubeConfig* tab. In a second or two, you will see the contents of the
    kubeconfig file. Click the blue *Download KubeConfig* button to download
    it locally.

    ![Kubeconfig view](assets/shot-07.png)

    The kubeconfig file you get has a name similar to this one:

    ```plain
    kubeconfig--<cluster_name>--<region_name>--<alphanum_id>.yaml
    ```

    Feel free to rename it to something simpler, like `config`.
=== "OpenStack CLI"
    To download the kubeconfig file for your Kubernetes cluster, type
    the following:

    ```bash
    openstack coe cluster config --dir=${PWD} <cluster-name>
    ```

After saving the kubeconfig file locally, set the value of variable
`KUBECONFIG` to the full path of the file. Type, for example:

```bash
export KUBECONFIG=${PWD}/config
```

If you are currently managing only one cluster, and you already have its
kubeconfig file stored as `~/.kube/config`, then you do not need to set
the `KUBECONFIG` variable.

## Accessing the Kubernetes cluster with kubectl

You may now use `kubectl` to run commands against your cluster. See, for
instance, all cluster nodes...

```bash
kubectl get nodes
```

```plain
NAME                           STATUS   ROLES    AGE    VERSION
bangor-id6nijycp2wy-master-0   Ready    master   113m   v1.18.6
bangor-id6nijycp2wy-node-0     Ready    <none>   111m   v1.18.6
```

...or all running pods in every namespace:

```bash
kubectl get pods --all-namespaces
```

```plain
NAMESPACE     NAME                                         READY   STATUS    RESTARTS   AGE
kube-system   coredns-786ffb7797-tw2hg                     1/1     Running   0          167m
kube-system   coredns-786ffb7797-vbqwn                     1/1     Running   0          167m
kube-system   csi-cinder-controllerplugin-0                5/5     Running   0          167m
kube-system   csi-cinder-nodeplugin-4nr69                  2/2     Running   0          166m
kube-system   csi-cinder-nodeplugin-vtwqf                  2/2     Running   0          167m
kube-system   dashboard-metrics-scraper-6b4884c9d5-4mlrg   1/1     Running   0          167m
kube-system   k8s-keystone-auth-wk5v2                      1/1     Running   0          167m
kube-system   kube-dns-autoscaler-75859754fd-2wsd9         1/1     Running   0          167m
kube-system   kube-flannel-ds-7z9dp                        1/1     Running   0          167m
kube-system   kube-flannel-ds-dmvk6                        1/1     Running   0          166m
kube-system   kubernetes-dashboard-c98496485-stn42         1/1     Running   0          167m
kube-system   magnum-metrics-server-79556d6999-xdlpm       1/1     Running   0          167m
kube-system   npd-5p6gk                                    1/1     Running   0          165m
kube-system   openstack-cloud-controller-manager-44rz9     1/1     Running   0          167m
```

## Defining a default storage class

An OpenStack Magnum-managed cluster does not automatically define a default [storage class](https://kubernetes.io/docs/concepts/storage/storage-classes/) for [dynamic volume provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/).
You should define one immediately upon cluster creation.

To do so, create a file named `storageclass.yaml` with the following content:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: csi-sc-cinderplugin
  annotations:
    "storageclass.kubernetes.io/is-default-class": "true"
provisioner: cinder.csi.openstack.org
```

You can use an alternate `name` if you prefer.

Then, apply the storage class definition:

```console
$ kubectl apply -f storageclass.yaml
storageclass.storage.k8s.io/csi-sc-cinderplugin created
```

Subsequently, any persistent volume claims will default to using this storage class, unless you choose to [override](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/#using-dynamic-provisioning) the default by setting the `spec.storageClassName` property.
