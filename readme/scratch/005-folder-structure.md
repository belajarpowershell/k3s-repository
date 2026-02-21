# Folder Structure

## extension naming

    .libsonnet = Jsonnet library files (meant to be imported, not evaluated)
    .jsonnet = Jsonnet files that produce output (meant to be evaluated)

## Directory structure

clusters
├─ k3s-master
│  ├─ apps.jsonnet           # generates ArgoCD Application manifests - add app to ArgoCD
│  ├─ cluster.jsonnet        # cluster-specific information
│  ├─ cert-manager           # application to deploy
│  │  └─ helm
│  │     └─ helm-chart.jsonnet  # application manifest
│  └─ ingress-nginx
│     └─ helm
│        └─ helm-chart.jsonnet
├─ k3s-01
│  ├─ apps.jsonnet
│  ├─ cluster.jsonnet
│  ├─ cert-manager
│  │  └─ helm
│  │     └─ helm-chart.jsonnet
│  └─ ingress-nginx
│     └─ helm
│        └─ helm-chart.jsonnet

libs
├─ k8s-application
│  ├─ application helm chart converted to jsonnet format
│  ├─ Helm charts downloaded locally and converted to jsonnet format
│  └─ Refer to [z000-helm2libsonet](/readme/z000-helm2libsonet.md)
├─ argo-cd-4.10.0
├─ global.libsonnet           # global configuration stored here
├─ argocd-projects.libsonnet  # creates projects in ArgoCD; imported in argo-cd-4.10.0
└─ argocd.libsonnet           # deploy ArgoCD in cluster; referenced in clusters\<cluster>\cluster.jsonnet

readme
└─ markdown files


# Directory Structure

<details>
<summary>clusters</summary>

k3s-master

├─ apps.jsonnet # generates ArgoCD Application manifests - add app to ArgoCD

├─ cluster.jsonnet # cluster-specific information
│
├─ cert-manager # application to deploy
│
│ └─ helm
│
│ └─ helm-chart.jsonnet # application manifest
│
└─ ingress-nginx
│
└─ helm
│
└─ helm-chart.jsonnet

k3s-01
├─ apps.jsonnet
├─ cluster.jsonnet
├─ cert-manager
│ └─ helm
│ └─ helm-chart.jsonnet
└─ ingress-nginx
└─ helm
└─ helm-chart.jsonnet
