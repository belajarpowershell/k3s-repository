## `init` Generates helm chart files for Jsonnet

```bash
mkdir -p ./templates && jsonnet -m . helm-chart.libsonnet && helm dependency build && [ -f './templates/_templates.jsonnet' ] && jsonnet ./templates _templates.jsonnet > ./templates/templates.yaml #|| exit 0

```

## `generate` Renders yaml from Helm charts

```bash
helm template $ARGOCD_APP_NAME . --api-versions monitoring.coreos.com/v1 --api-versions networking.k8s.io/v1/Ingress --namespace $ARGOCD_APP_NAMESPACE --include-crds

```

## Apply generated output using kubectl apply

```bash
helm template ingress-nginx . --namespace ingress-nginx  --include-crds   | kubectl apply -f - --dry-run=client


```

## Delete generated output using kubectl apply

```bash

helm template ingress-nginx . --namespace ingress-nginx  --include-crds   | kubectl delete -f - #--dry-run=client
```


add application to argocd

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ingress-nginx
spec:
  destination:
    namespace: ingress-nginx
    server: 'https://kubernetes.default.svc'
  source:
    path: clusters/k3s-master/ingress-nginx/helm
    repoURL: 'https://github.com/belajarpowershell/k3s-repository'
    targetRevision: HEAD
    directory: ## cannot use if plugin is required
      recurse: true
      jsonnet: {}
    plugin:
      name: jsonnet-helm-with-crds-plugin

  project: default
  syncPolicy:
    #automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true

```