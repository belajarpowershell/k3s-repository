# Cert-manager with `jsonnet-helm-with-crds`

when setting up a cluster , there will be default applications that will be required. This can be packaged in `clusters/default-apps.jsonnet`

ArgoCD app manifest

```yaml
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

```yaml
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
  syncPolicy:
    #automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
  sourceRef:
    plugin:
      name: jsonnet-helm-with-crds-plugin
```

```yaml
spec:
  source:
    plugin:
      name: jsonnet-helm-with-crds-plugin >> must match configmap name
```
