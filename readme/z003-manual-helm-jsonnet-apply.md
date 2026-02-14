# Manual helm jsonnet apply

The conversion from jsonnet to helm chart files is performed via steps specified in the ConfigMap.

```bash
extraObjects:
- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: jsonnet-helm-plugin
    labels:
      name: jsonnet-helm-plugin
    annotations: {}
  data:
    plugin.yaml: |
      apiVersion: argoproj.io/v1alpha1
      kind: ConfigManagementPlugin
      metadata:
        name: jsonnet-helm-plugin
      spec:
        version: v1.0
        init:
          command: ["/bin/sh", "-c"]
          args: ["mkdir -p ./templates && jsonnet -m . helm-chart.libsonnet && helm dependency build && [ -d './templates' ] && jsonnet ./templates/_templates.jsonnet > ./templates/templates.yaml || exit 0"]
        generate:
          command: ["/bin/sh", "-c"]
          args: ["helm template $ARGOCD_APP_NAME . --api-versions monitoring.coreos.com/v1 --api-versions networking.k8s.io/v1/Ingress --namespace $ARGOCD_APP_NAMESPACE"]
        discover:
          find:
            command: [sh, -c, 'if [ "$ARGOCD_ENV_PLUGIN" = "jsonnet-helm-plugin" ]; then echo Hi; fi' ]

- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: jsonnet-helm-with-crds-plugin
    labels:
      name: jsonnet-helm-with-crds-plugin
    annotations: {}
  data:
    plugin.yaml: |
      apiVersion: argoproj.io/v1alpha1
      kind: ConfigManagementPlugin
      metadata:
        name: jsonnet-helm-with-crds-plugin
      spec:
        version: v1.0
        init:
          command: ["/bin/sh", "-c"]
          args: [ "mkdir -p ./templates && jsonnet -m . helm-chart.libsonnet && helm dependency build && [ -f './templates/_templates.jsonnet' ] && jsonnet ./templates/_templates.jsonnet > ./templates/templates.yaml || exit 0" ]
        generate:
          command: ["/bin/sh", "-c"]
          args: [ "helm template $ARGOCD_APP_NAME . --api-versions monitoring.coreos.com/v1 --api-versions networking.k8s.io/v1/Ingress --namespace $ARGOCD_APP_NAMESPACE --include-crds" ]
        discover:
          find:
            command: [ sh, -c, "if [ \"$ARGOCD_ENV_PLUGIN\" = \"jsonnet-helm-with-crds-plugin\" ]; then echo Hi; fi" ]

```

The key steps are explained here.

## `discover` checks env for plugin to be used

```bash
command: [ sh, -c, "if [ \"$ARGOCD_ENV_PLUGIN\" = \"jsonnet-helm-with-crds-plugin\" ]; then echo Hi; fi" ]
```

The plugin variable is declared in the argocd manifest.
Here is an example for the cert-manager manifest that adds the cert-manager to ArgoCD.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cert-manager
spec:
  destination:
    namespace: cert-manager
    server: 'https://kubernetes.default.svc'
  source:
    path: clusters/k3s-master/cert-manager/helm
    repoURL: 'https://github.com/belajarpowershell/k3s-repository'
    targetRevision: HEAD
    directory:
      recurse: true
      jsonnet: {}
  project: default
  syncPolicy:
    # automated:
    #   prune: true
    #   selfHeal: true
    # syncOptions:
    #   - CreateNamespace=true
  sourceRef:
    plugin:
      name: jsonnet-helm-with-crds-plugin


```

## `init` Generates helm chart files for Jsonnet

```bash
mkdir -p ./templates && jsonnet -m . helm-chart.libsonnet && helm dependency build && [ -f './templates/_templates.jsonnet' ] && jsonnet ./templates _templates.jsonnet > ./templates/templates.yaml #|| exit 0

```

## `generate` Renders yaml from Helm charts

```bash
helm template $ARGOCD_APP_NAME . --api-versions monitoring.coreos.com/v1 --api-versions networking.k8s.io/v1/Ingress --namespace $ARGOCD_APP_NAMESPACE --include-crds

```

## Apply generated output using kubectl apply

```bash
helm template argocd . --namespace argocd  --include-crds    | kubectl apply -f -  --namespace argocd --dry-run=client


```

## Delete generated output using kubectl apply

```bash

helm template argocd . --namespace argocd  --include-crds   | kubectl delete -f - #--dry-run=client
```


```yaml

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx-ingress
  namespace: argocd
spec:
  project: platform

  destination:
    name: in-cluster
    namespace: ingress-nginx
  source:
    repoURL: 'https://github.com/belajarpowershell/k3s-repository'
    targetRevision: HEAD
    path: clusters/k3s-master/ingress-nginx/helm
    plugin:
      env:
        - name: PLUGIN
          value: jsonnet-helm
  syncPolicy:
    syncOptions:
      - CreateNamespace=true


```