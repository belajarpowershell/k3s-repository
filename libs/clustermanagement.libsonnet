local argocd = import 'argocd.libsonnet';
local globals = import 'globals.libsonnet';
local kube = import 'kube.libsonnet';


// local getApplicationPath(cluster, name) =
//   if std.objectHas(cluster, 'environment')
//   then 'clusters/' + cluster.region + '/' + cluster.countryFactory + '/' + cluster.environment + '/' + cluster.name + '/' + name else
//     if std.objectHas(cluster, 'region')
//     then 'clusters/' + cluster.region + '/' + cluster.countryFactory + '/' + cluster.name + '/' + name
//     else 'clusters/' + cluster.name + '/' + name;

local getApplicationPath(cluster, name) =
  if name == 'argocd' then
    // Special path for ArgoCD
    'argocd/' + cluster.name
  else
    'clusters/' + cluster.name + '/' + name;


local isPlatformApplications(name, namespace) =
  local platformNamespaces = [
    'argocd',
    'ingress-nginx',
  ];
  std.member(platformNamespaces, namespace);


{

  //Designed for use in the cluster app
  //ArgoCD Application meant to hold other applications for each individual app. One per destination cluster.
  // ClusterApp(cluster):: argocd.Application(cluster.name) {
  //   metadata+: {
  //     namespace: 'argocd',
  //   },
  //   spec+: {
  //     destination+: {
  //       server: 'https://kubernetes.default.svc',
  //       namespace: 'argocd',
  //     },
  //     project: 'default',  //cluster.name,
  //     source: {
  //       path: 'clusters/' + cluster.region + '/' + cluster.countryFactory + '/' + cluster.environment + cluster.name,
  //       #repoURL: globals.gitrepossshkey.kubeApplicationsState,
  //       repoURL: globals.gitrepos.kubeApplicationsState,
  //       targetRevision: 'HEAD',
  //     },
  //     // syncPolicy: {
  //     //   automated: {},
  //     // },
  //   },
  // },

  // ClusterAppWithAutoSync(cluster):: $.ClusterApp(cluster) {
  //   spec+: {
  //     syncPolicy: {
  //       automated: {},
  //     },
  //   },
  // },

  // BaseClusterApp(cluster):: argocd.Application(cluster.name + '-cluster-app') {
  //   metadata+: {
  //     namespace: 'argocd',
  //   },
  //   spec+: {
  //     destination+: {
  //       name: 'in-cluster',
  //       namespace: 'argocd',
  //     },
  //     project: 'default',  //cluster.name,
  //     source: {
  //       path: 'clusters/' + cluster.region + '/' + cluster.countryFactory + '/' + cluster.environment + '/' + cluster.name,
  //       repoURL: 'https://github.com/belajarpowershell/k3s-repository.git',
  //       targetRevision: 'HEAD',
  //     },
  //     syncPolicy: {
  //       automated: {},
  //     },
  //   },
  // },

  // ClusterAppProject(cluster):: argocd.AppProject(cluster.name, cluster.uri) {
  //   metadata+: {
  //     namespace: 'argocd',
  //   },
  //   spec+: {
  //     sourceRepos: [
  //       #globals.gitrepossshkey.kubeApplicationsState,
  //       globals.gitrepos.kubeApplicationsState,
  //     ],
  //     destinations: std.flattenArrays(
  //       [
  //         [
  //           {
  //             server: 'https://kubernetes.default.svc',
  //             namespace: 'argocd',
  //           },
  //         ],
  //         [
  //           {
  //             server: cluster.uri,
  //             namespace: ns,
  //           }
  //           for ns in globals.clusterAppNamespaces
  //         ],
  //       ],
  //     ),
  //   },
  // },

  //This is the normal yaml/jsonnet directory cluster application
  App(cluster, name, namespace):: argocd.Application(cluster.name + '-' + name) {
    spec+: {
      destination+: {
        //name:  #cluster.nickname,
        server: cluster.server,
        namespace: namespace,
      },
      project: if isPlatformApplications(name, namespace) then 'platform' else 'default',
      source: {
        path: getApplicationPath(cluster, name),
        #repoURL: globals.gitrepossshkey.kubeApplicationsState,
        repoURL: globals.gitrepos.kubeApplicationsState,
        targetRevision: 'HEAD',
      },
      syncPolicy: {
        syncOptions: [
          'CreateNamespace=true',
        ],
      },
    },
  },

  // //This is the normal yaml/jsonnet directory cluster application but with AutoSync
  // AppWithAutoSync(cluster, name, namespace):: argocd.Application(cluster.name + '-' + name) {
  //   spec+: {
  //     destination+: {
  //       //name: cluster.server, #cluster.nickname,
  //       server: cluster.server,
  //       namespace: namespace,
  //     },
  //     project: if isPlatformApplications(name, namespace) then 'platform' else 'default',
  //     source: {
  //       path: getApplicationPath(cluster, name),
  //       #repoURL: globals.gitrepossshkey.kubeApplicationsState,
  //       repoURL: globals.gitrepos.kubeApplicationsState, 
  //       targetRevision: 'HEAD',
  //     },
  //     syncPolicy: {
  //       // automated: {
  //       //   prune: true,
  //       //   selfHeal: true,
  //       // },
  //       syncOptions: [
  //         'CreateNamespace=true',
  //       ],
  //     },
  //   },
  // },


  //Use a custom Config Management Plugin - https://argoproj.github.io/argo-cd/user-guide/config-management-plugins/
  JsonnetHelmApplication(cluster, name, namespace):: $.App(cluster, name, namespace) {
    spec+: {
      project: if isPlatformApplications(name, namespace) then 'platform' else 'default',
      source+: {
        // plugin: {
        //   name: 'jsonnet-helm',
        //   // env: [
        //   //   {
        //   //     name: 'PLUGIN',
        //   //     value: 'jsonnet-helm',
        //   //   },
        //   // ],
        // },

        plugin: {
        //works 19 Feb 2026
          env: [
            {
              name: 'PLUGIN',
              value: 'jsonnet-helm',
            },
          ],
        },

      },
      syncPolicy: {
       //automated: {},
       syncOptions: [
         'CreateNamespace=true',
       ],
      },
    },
  },

  //Use a custom Config Management Plugin - https://argoproj.github.io/argo-cd/user-guide/config-management-plugins/
  JsonnetHelmApplicationWithCrds(cluster, name, namespace):: $.App(cluster, name, namespace) {
    spec+: {
      project: if isPlatformApplications(name, namespace) then 'platform' else 'default',
      source+: {
        // plugin: {
        //   name: 'jsonnet-helm-with-crds',
        //   // env: [
        //   //   {
        //   //     name: 'PLUGIN',
        //   //     value: 'jsonnet-helm-with-crds',
        //   //   },
        //   // ],
        // },

        plugin: {
          env: [
            {
              name: 'PLUGIN',
              value: 'jsonnet-helm-with-crds',
            },
          ],
        },
      },
      syncPolicy: {
        //automated: {},
        syncOptions: [
          'CreateNamespace=true',
        ],
      },
    },
  },

  // JsonnetHelmApplicationWithCrdsAutosync(cluster, name, namespace):: $.App(cluster, name, namespace) {
  //   spec+: {
  //     source+: {
  //       plugin: {
  //         env: [
  //           {
  //             name: 'PLUGIN',
  //             value: 'jsonnet-helm-with-crds',
  //           },
  //         ],
  //       },
  //     },
  //     syncPolicy+: {
  //      automated: {},
  //      syncOptions: [
  //        'CreateNamespace=true',
  //      ],
  //     },
  //   },
  // },

  // JsonnetHelmApplicationCustomProj(cluster, name, namespace, project):: $.App(cluster, name, namespace) {
  //   spec+: {
  //     project: project,
  //     source+: {
  //       plugin: {
  //         env: [
  //           {
  //             name: 'PLUGIN',
  //             value: 'jsonnet-helm',
  //           },
  //         ],
  //       },
  //     },
  //   },
  // },
}
