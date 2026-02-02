

```
          init:
            command: ["/bin/sh", "-c"]
            args: ["mkdir -p ./templates && jsonnet -m . helm-chart.libsonnet && helm dependency build && [ -f './templates/_templates.jsonnet' ] && jsonnet ./templates/_templates.jsonnet > ./templates/templates.yaml || exit 0"]
          generate:
            command: ["/bin/sh", "-c"]
            args: ["helm template $ARGOCD_APP_NAME . --api-versions monitoring.coreos.com/v1 --api-versions networking.k8s.io/v1/Ingress --namespace $ARGOCD_APP_NAMESPACE --include-crds"]
          discover:
            find:
              command: [sh, -c, 'if [ \"$ARGOCD_ENV_PLUGIN\" = \"jsonnet-helm-with-crds\" ]; then echo Hi; fi' ]
```


## Init

Validates helm charts for deployment.

```
          init:
            command: ["/bin/sh", "-c"]
            args: ["mkdir -p ./templates && jsonnet -m . helm-chart.libsonnet && helm dependency build && [ -f './templates/_templates.jsonnet' ] && jsonnet ./templates/_templates.jsonnet > ./templates/templates.yaml || exit 0"]
```

## Generate
Generates Yaml to be deployed

```
          generate:
            command: ["/bin/sh", "-c"]
            args: ["helm template $ARGOCD_APP_NAME . --api-versions monitoring.coreos.com/v1 --api-versions networking.k8s.io/v1/Ingress --namespace $ARGOCD_APP_NAMESPACE --include-crds"]

```

## Build Helm dependancies

```
helm dependency build
```
##