Once k3s2 intial setup is done, the token and CA would have been stored in environment

Run the following to create the secret in k3s1


```
cat <<EOF | kubectl apply -n argocd -f -
apiVersion: v1
kind: Secret
metadata:
  name: k3s2-secret
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name: k3s2
  server: https://k3s2.k8s.lab
  config: |
    {
      "bearerToken": "${token}",
      "tlsClientConfig": {
        "serverName": "k3s2.k8s.lab",
        "caData": "${ca}"
      }
    }
EOF

```