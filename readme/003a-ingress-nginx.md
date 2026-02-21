# Install ingress-nginx

## Install via helm

```bash
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 4.10.0 -n ingress-nginx --create-namespace --set controller.extraArgs.enable-ssl-passthrough=true 

```

## install via helm jsonnet

```bash
$ARGOCD_APP_NAME=k3s-master-ingress-nginx # This is to ensure when adding this app to ArgoCD the existing resources are added
```

```bash
mkdir -p ./templates && jsonnet -m . helm-chart.libsonnet && helm dependency build && [ -f './templates/_templates.jsonnet' ] && jsonnet ./templates _templates.jsonnet > ./templates/templates.yaml 
helm template k3s-master-ingress-nginx . --namespace ingress-nginx   --include-crds    | kubectl apply -f -  --namespace ingress-nginx --dry-run=client

```
$ARGOCD_APP_NAME K3S-MASTER-INGRESS-NGINX