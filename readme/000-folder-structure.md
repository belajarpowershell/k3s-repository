# Folder Structure

The folder structure is important as the separation of the functionality is done at the folder level.


```tree
k3s-repository/
├── argocd/        # ArgoCD installation per cluster
├── clusters/      # Cluster-specific applications
├── libs/          # Vendored Helm charts (Jsonnet-ready)
├── platform/      # Global app-of-apps
├── scripts/       # Automation helpers
├── readme/        # Documentation
└── scratch/       # Experiments
```

In the documentation, when `libs` folder or `argocd` folder is mentioned reference this tree. This will provide a perspective.

Here is a more detailed tree with folder content

```
~/k3s-repository # tree -L 2
.
├── README.md
├── alias.sh
├── argocd
│   ├── k3s-master
│   └── readme.md
├── clusters
│   ├── default-apps.jsonnet
│   ├── k3s-01
│   ├── k3s-02
│   ├── k3s-03
│   └── k3s-master
├── libs
│   ├── 001-example
│   ├── argo-cd-6.7.6
│   ├── argo-cd-9.4.3
│   ├── argocd-projects.libsonnet
│   ├── argocd.libsonnet
│   ├── cert-manager-ca
│   ├── cert-manager-v1.14.4
│   ├── clustermanagement.libsonnet
│   ├── clusters
│   ├── globals.libsonnet
│   ├── ingress-nginx-4.10.0
│   ├── kube.libsonnet
│   ├── servicePrincipals.json
│   └── web-app-jsonnet
├── platform
│   └── global-app-of-apps.jsonnet
├── readme
│   ├── 000-aliases.md
│   ├── 000-folder-structure.md
│   ├── 000-prerequisites.md
│   ├── 0001b-argocd-jsonnet-install.md
│   ├── 0001b-argocd-manual-install.md
│   ├── 001-kubeconfig.md
│   ├── 003-[explainer]-deploy-jsonnet.md
│   ├── 003a-ingress-nginx.md
│   ├── 003c-plugin-setup.md
│   ├── scratch
│   └── summary.md
├── scratch
│   └── apps copy
├── scripts
│   ├── add-new-cluster-2-argocd
│   └── helm2jsonnet
└── templates
```