Once the service account and argocd-manager-secret.yaml is created
save the bearer token and CA certificate.

```
ca=$(kubectl get -n kube-system secret/argocd-manager-token -o jsonpath='{.data.ca\.crt}')

token=$(kubectl get -n kube-system secret/argocd-manager-token -o jsonpath='{.data.token}' | base64 --decode)
```