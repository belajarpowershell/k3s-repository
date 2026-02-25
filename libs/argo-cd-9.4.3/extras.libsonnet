local kube = import '../kube.libsonnet';
local kubeExtensions = import '../kubeExtensions.libsonnet';
local globals = import '../globals.libsonnet';

# import k8s clusters to ArgoCD
local clusterOnboarding = import './cluster-onboarding.jsonnet'; 
{
  JsonnetHelmWithCrdsPlugin(p):: kube.ConfigMap('jsonnet-helm-with-crds') {
    data: {
      'plugin.yaml': |||
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
              glob: "**/helm-chart.libsonnet"
      |||,
    },
  },

  
  JsonnetHelmPlugin(p):: kube.ConfigMap('jsonnet-helm') {
    data: {
      'plugin.yaml': |||
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
              glob: "**/helm-chart.libsonnet"
      |||,
    },
  },

}