# Export KUBECONFIG

### to validate as adding cluster to ARGOCD as a manual step is more efficient!!

If you have your Kubconfig as follows

```bash
kubectl config get-contexts
CURRENT   NAME             CLUSTER      AUTHINFO                  NAMESPACE
*         k3s-01       k3s-01       k3s-01-default-user       
          k3s-02       k3s-02       k3s-02-default-user       
          k3s-03       k3s-03       k3s-03-default-user       
          k3s-master   k3s-master   k3s-master-default-user   argocd

```

The the following will extract each kubeconfig to files.

Run the command in `libs/cluster`

```bash
kubectl config view --raw --minify --flatten --context=k3s-01 > k3s-01.kubeconfig
kubectl config view --raw --minify --flatten --context=k3s-02 > k3s-02.kubeconfig
kubectl config view --raw --minify --flatten --context=k3s-03 > k3s-03.kubeconfig
kubectl config view --raw --minify --flatten --context=k3s-master > k3s-master.kubeconfig
```


```
-argocd
-cluster
-libs/cluster
    -  k3s-01.kubeconfig
    -  k3s-02.kubeconfig
    -  k3s-03.kubeconfig
    -  k3s-master.kubeconfig
```

This will be required when installing ArgoCD .