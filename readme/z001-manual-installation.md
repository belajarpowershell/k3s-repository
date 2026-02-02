# Manual instatllation.

## Ingress

```

kubectl create namespace ingress-nginx

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 4.10.0 -n ingress-nginx --create-namespace --set controller.extraArgs.enable-ssl-passthrough=true 

#remove
helm uninstall ingress-nginx -n ingress-nginx



```

##  ARGOCD 

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

```
helm upgrade --install argocd argo/argo-cd \
  --version 4.10.0 \
  --namespace argocd --create-namespace \
  --set dex.enabled=false \
  --set notifications.enabled=false \
  --set applicationSet.enabled=true \
  --set server.ingress.enabled=true \
  --set server.ingress.hostname="argocd-master.k8s.lab" \
  --set server.ingress.ingressClassName=nginx \
  --set global.domain=k8s.lab \
  --set server.extraArgs={--insecure} \
  --set server.insecure=true \
  --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io/backend-protocol"="HTTP" \
  --set configs.secret.argocdServerAdminPassword='$2b$12$3peDOQrx3EVLpfCJ.lRQQOSVNBiyjbJ0ofT79qrsdJvU9eTBG.mFm' \
  --set configs.secret.argocdServerAdminPasswordMtime="$(date +%FT%T%Z)"  

#argocdServerAdmin=admin
#argocdServerAdminPassword=YourSecurePassword


helm uninstall argocd -n argocd

```
https://argocd-master.k8s.lab/