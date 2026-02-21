local clustermgmt = import '../libs/clustermanagement.libsonnet';
local kube = import '../libs/kube.libsonnet';


{
  DefaultApplications(p):: {
    // Deploy ArgoCD only on k3s-master
    [if p.name == 'k3s-master' then "argocd"]:
      clustermgmt.JsonnetHelmApplicationWithCrds(p, 'argocd', 'argocd') {
        spec+: {
          project: 'platform',
          syncPolicy: {
            syncOptions: [
              'CreateNamespace=true',
            ],
          },
        },
      },


    // cert-manager → deploy to all clusters
    cert_manager: clustermgmt.JsonnetHelmApplicationWithCrds(p, 'cert-manager', 'cert-manager') {
      spec+: {
        project: 'platform',
        syncPolicy: {
          syncOptions: [
            'CreateNamespace=true',
          ],
        },
      },
    },

    // ingress-nginx → deploy to all clusters
    ingress_nginx: clustermgmt.JsonnetHelmApplication(p, 'ingress-nginx', 'ingress-nginx') {
      spec+: {
        destination+: {
          name: p.clusterName,
          server: '',  // leave empty for default kubeconfig context
        },
        project: 'platform',
        syncPolicy: {
          automated: {},
          syncOptions: [
            'CreateNamespace=true',
          ],
        },
      },
    },
  },

##
  MonitoringStack(p):: {
    // prometheus: clustermgmt.JsonnetHelmApplication(p, 'prometheus', 'monitoring') {
    //   spec+: {
    //     project: 'platform',
    //     syncPolicy: {
    //       automated: {
    //         prune: true,
    //         selfHeal: false,
    //       },
    //       syncOptions: [
    //         'CreateNamespace=true',
    //         'ApplyOutOfSyncOnly=true',
    //         //'Replace=true',
    //       ],
    //     },
    //   },
    // },

    // // Workaround for prometheus CRD being too big..Split the installation of kube-prometheus-stack into two ArgoCD app,
    // // 1) To installs prometheus Helm chart , 2) To install CRD only
    // // https://github.com/prometheus-operator/prometheus-operator/issues/4439#issuecomment-1030198014
    // prometheusCRDs: clustermgmt.App(p, 'prometheus-crds', 'monitoring') {
    //   spec+: {
    //     project: 'platform',
    //     source+: {
    //       path: 'charts/kube-prometheus-stack/charts/crds/crds/',
    //       repoURL: 'https://github.com/prometheus-community/helm-charts.git',
    //       targetRevision: 'kube-prometheus-stack-54.0.1',
    //     },
    //     syncPolicy: {
    //       automated: {
    //         prune: true,
    //         selfHeal: false,
    //       },
    //       syncOptions: [
    //         'ApplyOutOfSyncOnly=true',
    //         'Replace=true',
    //       ],
    //     },
    //   },
    // },

    // // Custom prometheus rules to monitor platform component.
    // prometheusRules: clustermgmt.App(p, 'prometheus-rules', 'monitoring') {
    //   spec+: {
    //     project: 'platform',
    //     syncPolicy: {
    //       automated: {
    //         prune: true,
    //         selfHeal: false,
    //       },
    //       syncOptions: [
    //         'ApplyOutOfSyncOnly=true',
    //         'Replace=true',
    //       ],
    //     },
    //     source+: {
    //       path: 'libs/monitoring/platform-prometheus-rules',
    //       directory+: {
    //         jsonnet: {
    //           extVars: [
    //             {
    //               name: 'cluster-type',
    //               value: p.clustertype,
    //             },
    //             {
    //               name: 'cluster-name',
    //               value: p.name,
    //             },
    //             {
    //               name: 'k3s-type',
    //               value: if std.objectHas(p, 'k3s_type') then p.k3s_type else '',
    //             },
    //           ],
    //         },
    //       },
    //     },
    //   },
    // },

    // // https://github.com/cloudworkz/kube-eagle
    // kube_eagle: clustermgmt.JsonnetHelmApplication(p, 'kube-eagle', 'kube-eagle') {
    //   spec+: {
    //     project: 'platform',
    //     syncPolicy: {
    //       automated: {
    //         prune: true,
    //         selfHeal: false,
    //       },
    //       syncOptions: [
    //         'CreateNamespace=true',
    //       ],
    //     },
    //   },
    // },

    // grafanaOperator: clustermgmt.JsonnetHelmApplicationWithCrdsAutosync(p, 'grafana-operator', 'grafana-operator') {
    //   spec+: {
    //     project: 'platform',
    //     syncPolicy: {
    //       automated: {
    //         prune: true,
    //         selfHeal: false,
    //       },
    //     },
    //   },
    // },
    // grafanaDashboards: clustermgmt.App(p, 'grafana-dashboards', 'grafana-operator') {
    //   spec+: {
    //     project: 'platform',
    //     source+: {
    //       path: 'libs/platform-components/grafana-operator-2.9.3/dashboards',
    //     },
    //     syncPolicy: {
    //       automated: {
    //         prune: true,
    //         selfHeal: false,
    //       },
    //       syncOptions: [
    //         'CreateNamespace=true',
    //       ],
    //     },
    //   },
    // },
  },



  Policies(p):: {
    // gatekeeper: clustermgmt.JsonnetHelmApplicationWithCrds(p, 'gatekeeper', 'gatekeeper-system') {
    //   spec+: {
    //     syncPolicy: {
    //       automated: {},
    //       syncOptions: [
    //         'CreateNamespace=true',
    //       ],
    //     },
    //   },
    // },

    // policies: clustermgmt.App(p, 'policies', 'gatekeeper-system') {
    //   spec+: {
    //     syncPolicy: {
    //       //automated: {},
    //     },
    //   },
    // },
  },
}
