# Installing ArgoCD

On `k3s-master` the very first application installed is ArgoCD.

The initial manual setup using `helm` is shared as this forms the basis of the automated configuraion.
The manual configuration was fine tuned to have a working baseline.

## Manual Helm only installation of ARGOCD

[ArgoCD helm installation](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd)

Add the ArgoCD `helm` repository


```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

### ArgoCD Helm install command

ArgoCD default setup configuration is generated with multiple iterations to ensure the ArgoCD meets your requirement.

```bash
helm upgrade --install argocd argo/argo-cd \
  --version 6.7.6 \
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

### ArgoCD login creds

To ensure the same login credentials are used for every install, the following creds are used.

```txt
argocdServerAdmin=admin
argocdServerAdminPassword=YourSecurePassword
```


## ARGOCD installed successfully.

Accessed via 
[argocd-master.k8s.lab](argocd-master.k8s.lab)


## Jsonnet-helm ArgoCD installation

The installation method will involve manual deployment of ArgoCD using the helm-jsonnet method via commandline.

Continue with 

[Jsonnet-helm ArgoCD installation](000b-argocd-jsonnet-install.md)
