# Manual instatllation

Install in sequence

## Ingress

```bash

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 4.10.0 -n ingress-nginx --create-namespace --set controller.extraArgs.enable-ssl-passthrough=true 

```

Manual apply via kubectl

create namespace first

```bash
k create ns ingress-nginx
```

```bash

~/k3s-repository/clusters/k3s-master/ingress-nginx/helm

jsonnet helm-chart.jsonnet | kubectl apply -f -

```

## remove

```bash
helm uninstall ingress-nginx -n ingress-nginx

```

## ARGOCD

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

```bash
helm upgrade --install argocd argo/argo-cd \
  --version 4.10.0 \
  --namespace argocd --create-namespace \
  --set dex.enabled=false \
  --set notifications.enabled=false \
  --set applicationSet.enabled=true \
  --set server.ingress.enabled=true \
  --set server.ingress.hosts[0]="argocd-master.k8s.lab" \
  --set server.ingress.name=argocd \
  --set server.ingress.ingressClassName=nginx \
  --set global.domain=k8s.lab \
  --set hostname=argocd-master.k8s.lab \
  --set server.extraArgs={--insecure} \
  --set server.insecure=true \
  --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io/backend-protocol"="HTTP" \
  --set configs.secret.argocdServerAdminPassword='$2b$12$3peDOQrx3EVLpfCJ.lRQQOSVNBiyjbJ0ofT79qrsdJvU9eTBG.mFm' \
  --set configs.secret.argocdServerAdminPasswordMtime="$(date +%FT%T%Z)" 
```

argocdServerAdmin=admin
argocdServerAdminPassword=YourSecurePassword

```bash
helm uninstall argocd -n argocd

```

[argocd URL](https://argocd-master.k8s.lab/)
[k3s-master ](https://k3s-master.k8s.lab/)

## Install configmap

## Container setup with custom tools

- helm
- jsonnet
-

### ARGOCD project manifest

<!-- ---
project: default
source:
  repoURL: 'https://github.com/belajarpowershell/k3s-repository'
  path: argocd/k3s-master/helm/argo-cd-4.10.0
  targetRevision: HEAD
  helm:
    valueFiles:
      - values.yaml
      - setup-values.yaml
      - argocd-configmap.yaml
      - argocd-repo-server-values.yaml
destination:
  server: 'https://kubernetes.default.svc'
  namespace: argocd
--- -->

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: 'argocd'
spec:
  destination:
    name: 'argocd'
    namespace: argocd
    server: 'https://kubernetes.default.svc'
  source:
    path: 'argocd/k3s-master/helm/argo-cd-4.10.0'
    repoURL: 'https://github.com/belajarpowershell/k3s-repository'
    targetRevision: HEAD
    helm:
      valueFiles:
        - values.yaml
        - setup-values.yaml
        - argocd-configmap.yaml
        - argocd-repo-server-values.yaml
  project: 'default'

```

`values.yaml`

- default helm values without changes

`setup-values.yaml`

- first time setup values to enable the required features for ArgoCD to function.

`argocd-configmap.yaml`

- the configmap for jsonnet-helm plugins.

`argocd-repo-server-values.yaml`

- the `repo-server` configuration to enable plugins in ArgoCD



## Apply generated output using kubectl apply

```bash
helm template argocd . --namespace argocd  --include-crds    | kubectl apply -f -  --namespace argocd --dry-run=client


```