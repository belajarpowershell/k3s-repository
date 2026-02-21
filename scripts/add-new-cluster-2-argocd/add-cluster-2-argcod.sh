## this script must be run on the remote k8s cluster to be added to ArgoCD ( hosted on k3s-master)

## replaces CLI argocd cluster add

kubectl create serviceaccount argocd-manager -n kube-system

kubectl create clusterrolebinding argocd-manager-binding \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:argocd-manager

TOKEN=$(kubectl create token argocd-manager -n kube-system)
