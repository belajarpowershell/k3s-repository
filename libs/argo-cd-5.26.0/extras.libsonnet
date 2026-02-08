local kube = import '../kube.libsonnet';
local kubeExtensions = import '../kubeExtensions.libsonnet';
local globals = import '../globals.libsonnet';

{
    JsonnetHelmWithCrdsPlugin(p):: kube.ConfigMap('jsonnet-helm-with-crds-plugin') {
    data: {
      'plugin.yaml': |||
        apiVersion: argoproj.io/v1alpha1
        kind: ConfigManagementPlugin
        metadata:
          name: jsonnet-helm-with-crds-plugin
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
              command: [sh, -c, 'if [ "$ARGOCD_ENV_PLUGIN" = "jsonnet-helm-with-crds-plugin" ]; then echo Hi; fi' ]
      |||,
    },
  },

  
  JsonnetHelmPlugin(p):: kube.ConfigMap('jsonnet-helm-plugin') {
    data: {
      'plugin.yaml': |||
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
      |||,
    },
  },
}