# Initial setup Prerequisites

## Tools

The following tools are required

### [jsonnet](https://github.com/google/jsonnet)

- This is the main tool required to generate yaml manifests.
- Supports variables allowing to templatize manifests to generate yaml manifests based on parameters i.e. cluster , namespace.
- Logic checks i.e. ( if.. then else) support allowes for further customization.  

### [yq](https://mikefarah.gitbook.io/yq)

- `yq`  Converts `yaml` to `json`

- The output is usually with the extention `libsonnet`/`jsonnet`.

### [helm](https://helm.sh/docs/intro/install/)

- Required for the helm dependancy build. i.e. convert `helm-chart.libsonnet` to real Helm chart structure on disk.

- 

### [jq](https://jqlang.org/)

- `jq` will be required when working with Kubernetes json outputs.
- Helps with automation.
- json output can be filtered for specific elements.
  Output for`kubectl get pods -n argocd -o json` can be very complex to read 
  With `jq` the outputs can be selective.

    ```terminal

    kubectl get pods -n argocd -o json | jq '.items[].metadata.name'

    "argocd-applicationset-controller-59fdb85f57-852jg"
    "argocd-redis-7f89d56686-tccwh"
    "argocd-notifications-controller-5cbc476789-zgqjt"
    "argocd-application-controller-0"
    "argocd-server-787fc676cc-kx75f"
    "argocd-repo-server-54d89954b7-r7mqs"
    ```

### [k3s](https://k3s.io/)

As a proof of concept, [k3s](https://k3s.io/) is deployed on Virtual Machines built on HyperV.

## Kubernetes Cluster

To perform the application deployments in this Proof of Concept. We have the following [k3s](https://k3s.io/) clusters

### `k3s-master`

- This will function as the master cluster hosting ArgoCD

We then have "child" clusters to deploy applications from `k3s-master` ArgoCD

### `k3s-01`

### `k3s-02`

### `k3s-03`
