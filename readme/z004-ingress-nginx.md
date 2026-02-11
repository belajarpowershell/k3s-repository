# Ingress-nginx `jsonnet-helm`

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx-ingress
  namespace: argocd
spec:
  project: default
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: ingress-nginx
  source:
    repoURL: 'https://github.com/belajarpowershell/k3s-repository'
    targetRevision: HEAD
    path: 'clusters/k3s-master/ingress-nginx/helm'
    directory:
      recurse: true
      jsonnet: {}                   # triggers CMP plugin
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
  sourceRef:
    plugin:
      name: jsonnet-helm          # plugin without CRDs

```

```yaml

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx-ingress
  namespace: argocd
spec:
  project: default
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: ingress-nginx
  source:
    repoURL: 'https://github.com/belajarpowershell/k3s-repository'
    targetRevision: HEAD
    path: 'clusters/k3s-master/ingress-nginx/helm'
    plugin:
      name: jsonnet-helm-with-crds-plugin         # plugin without CRDs

```