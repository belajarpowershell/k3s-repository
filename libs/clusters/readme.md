# Export KUBECONFIG

If you have your Kubconfig as follows

```bash
kubectl config get-contexts
CURRENT   NAME             CLUSTER      AUTHINFO                  NAMESPACE
*         ctx-k3s-01       k3s-01       k3s-01-default-user       
          ctx-k3s-02       k3s-02       k3s-02-default-user       
          ctx-k3s-03       k3s-03       k3s-03-default-user       
          ctx-k3s-master   k3s-master   k3s-master-default-user   argocd

```

The the following will extract each kubeconfig to files.

```bash
kubectl config view --raw --minify --flatten --context=ctx-k3s-01 > k3s-01.kubeconfig
kubectl config view --raw --minify --flatten --context=ctx-k3s-02 > k3s-02.kubeconfig
kubectl config view --raw --minify --flatten --context=ctx-k3s-03 > k3s-03.kubeconfig
kubectl config view --raw --minify --flatten --context=ctx-k3s-master > k3s-master.kubeconfig
```