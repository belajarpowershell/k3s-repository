{
  jsonnetHelmWithCrds: {
    apiVersion: "v1",
    kind: "ConfigMap",
    metadata: {
      name: "jsonnet-helm-with-crds",
      namespace: "argocd",
      labels: { name: "jsonnet-helm-with-crds" },
    },
    data: {
      "plugin.yaml": |||
        apiVersion: argoproj.io/v1alpha1
        kind: ConfigManagementPlugin
        metadata:
          name: jsonnet-helm-with-crds
        spec:
          version: v1.0
          init:
            command: ["/bin/sh", "-c"]
            args: ["mkdir -p ./templates && jsonnet -m . helm-chart.libsonnet && helm dependency build && [ -f './templates/_templates.jsonnet' ] && jsonnet ./templates/_templates.jsonnet > ./templates/templates.yaml || exit 0"]
          generate:
            command: ["/bin/sh", "-c"]
            args: ["helm template $ARGOCD_APP_NAME . --api-versions monitoring.coreos.com/v1 --api-versions networking.k8s.io/v1/Ingress --namespace $ARGOCD_APP_NAMESPACE --include-crds"]
          discover:
            find:
              command: [sh, -c, 'if [ \"$ARGOCD_ENV_PLUGIN\" = \"jsonnet-helm-with-crds\" ]; then echo Hi; fi' ]
      |||,
    },
  },

  jsonnetHelm: {
    apiVersion: "v1",
    kind: "ConfigMap",
    metadata: {
      name: "jsonnet-helm",
      namespace: "argocd",
      labels: { name: "jsonnet-helm" },
    },
    data: {
      "plugin.yaml": |||
        apiVersion: argoproj.io/v1alpha1
        kind: ConfigManagementPlugin
        metadata:
          name: jsonnet-helm
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
              command: [sh, -c, 'if [ \"$ARGOCD_ENV_PLUGIN\" = \"jsonnet-helm\" ]; then echo Hi; fi' ]
      |||,
    },
  },
}
