# Default applications for cluster

when setting up a cluster , there will be default applications that will be required. This can be packaged in `clusters/default-apps.jsonnet`

ArgoCD app manifest


```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: 'cert-manager'
spec:
  destination:
    name: 'cert-manager'
    namespace: 'cert-manager'
    server: 'https://kubernetes.default.svc'
  source:
    path: 'clusters/k3s-master/cert-manager/helm'
    directory:
      recurse: true
      jsonnet: {}   
    repoURL: 'https://github.com/belajarpowershell/k3s-repository'
    targetRevision: HEAD
  project: 'default'


```

```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cert-manager
spec:
  destination:
    namespace: cert-manager
    server: 'https://kubernetes.default.svc'
  source:
    path: clusters/k3s-master/cert-manager/helm
    repoURL: 'https://github.com/belajarpowershell/k3s-repository'
    targetRevision: HEAD
    directory:
      recurse: true
      jsonnet: {}
  project: default

```