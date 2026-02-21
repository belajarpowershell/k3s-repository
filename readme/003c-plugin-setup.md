#  Configmap 


Standard configuration

[config-management-plugins](https://argo-cd.readthedocs.io/en/stable/operator-manual/config-management-plugins/)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: jsonnet-helm
data:
  plugin.yaml: |
    apiVersion: argoproj.io/v1alpha1
    kind: ConfigManagementPlugin
    metadata:
      name: jsonnet-helm
    spec:
      version: v1.0
      init:
        command: ["/bin/sh", "-c"]
        args: ["..."]
      generate:
        command: ["/bin/sh", "-c"]
        args: ["..."]
      discover:
        find:
          glob: "helm-chart.libsonnet"

```

## `plugin.yaml`

### init 

- Prepare environment

### generate 

- Render manifests

### discover

- Tells argocd which apps should use this plugin

## Why ConfigMap is used

### `repo-server` 

- mounts CMP ConfigMaps to `/home/argocd/cmp-server/config/` 

- CMP server reads each `plugin.yaml` in that folde and registers plugin at runtime.

- each plugin with own `plugin.yaml`

- Without COnfigMAP ArgoCD does not know the plugin exists.

