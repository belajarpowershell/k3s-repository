# Installing ArgoCD

## Manual Helm only installation of ARGOCD

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

## Jsonnet-helm ArgoCD installtion.

The installation method will involve manual deployment of ArgoCD using the helm-jsonnet method via commandline.

Step 1 Download the helm chart locally to the libs folder.

THis script will perform the steps.

```bash
scripts/helm2jsonnet/convert-argocd.sh
```

Step 2
add customizations to the installation.
Lookup the customizations added `libs/argo-cd-5.26.0/customizations.libsonnet`

- Installation defaults

added subsequently

- Containers to perform conversion of helm.libsonnet to k8s manifest
- Plugins that use the containers with the coversion tools.
- k3s secrets containing the remote k3s KUBECONFIG as part of ARGOCD namespace.

Add using jsonnet helm

`$ARGOCD_APP_NAME=k3s-master-argocd # This is to ensure when adding this app to ArgoCD the existing resources are added`

```bash
mkdir -p ./templates && jsonnet -m . helm-chart.libsonnet && helm dependency build && [ -f './templates/_templates.jsonnet' ] && jsonnet ./templates _templates.jsonnet > ./templates/templates.yaml 

#helm template argocd . --namespace argocd  --include-crds    | kubectl apply -f -  --namespace argocd --dry-run=client

#helm template argocd . --namespace argocd  --include-crds    | kubectl delete -f -  --namespace argocd --dry-run=client

helm template k3s-master-argocd . --namespace argocd  --include-crds    | kubectl apply -f -  --namespace argocd --dry-run=client
```


## Install ARGOCD CLI 

```
apk add --no-cache curl ca-certificates

curl -sSL -o /usr/local/bin/argocd   https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64

chmod +x /usr/local/bin/argocd
argocd version


```

## Add cluster to ArgoCD via CLI

Change contexts for each k8s cluster before using ARGOCD cli to login
Adding remote cluster to Argocd via GitOps adds complexity for a PoC.
Adding remote clusters via ArgoCD CLI is quicker.

This is a one time effort
argocdServerAdmin=admin
argocdServerAdminPassword=YourSecurePassword

###

```bash
argocd login argocd-master.k8s.lab --insecure

```



```bash
kubectl config use-context k3s-master
argocd cluster add k3s-master  --insecure

kubectl config use-context k3s-01
argocd cluster add k3s-01  --insecure

kubectl config use-context k3s-02
argocd cluster add k3s-02  --insecure

kubectl config use-context k3s-03
argocd cluster add k3s-03  --insecure

```


## Install ingress-nginx

