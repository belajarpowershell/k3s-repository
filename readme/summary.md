I am setting up a POC to demonstrate platform engineering using jsonnet-helm + argocd.

I have 3 single node k3s setup 
k3s-master (single instance of ArgoCD ) 
k3s-01
k3s-02
k3s-03


argocd/
  k3s-master/
    helm/helm-chart.libsonnet

clusters/
  k3s-master/
    app-of-apps/apps.jsonnet ( not sure is should be helm-chart.libsonnet)
    cert-manager/helm/helm-chart.libsonnet
    ingress-nginx/ helm/helm-chart.libsonnet
    wen-app-jsonnet/yaml-jsonnet.jsonnet ( a better naming suggestion?)
    web-app-yaml/web-app.yaml ( a better naming suggestion?)
 libs/ 
 argo-cd-6.7.6/
 cert-manager-1.14.4/
 ingress-nginx-4.10.0/
 kubeconfig/


