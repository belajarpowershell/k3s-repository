local clusters = [
  'k3s-master',
  'k3s-01',
  'k3s-02',
  'k3s-03',
];

// Apps for k3s-master (ArgoCD + cert-manager + ingress-nginx)
// THis application is static , observe there are no variables.
// configuration references k3s-master only.
local masterApps = [
  // ArgoCD
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'k3s-master-argocd',
      namespace: 'argocd',
      labels: { app: 'argocd', cluster: 'k3s-master' },
    },
    spec: {
      project: 'platform',
      source: {
        repoURL: 'https://github.com/belajarpowershell/k3s-repository.git',
        targetRevision: 'HEAD',
        path: 'argocd/k3s-master',
        plugin: { env: [{ name: 'PLUGIN', value: 'jsonnet-helm-with-crds' }] },
      },
      destination: {
        server: 'https://kubernetes.default.svc',  // in-cluster
        namespace: 'argocd',
      },
      syncPolicy: { syncOptions: ['CreateNamespace=true'] },
    },
  },
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'k3s-master-vault',
      namespace: 'argocd',
      labels: { app: 'argocd', cluster: 'k3s-master' },
    },
    spec: {
      project: 'platform',
      source: {
        repoURL: 'https://github.com/belajarpowershell/k3s-repository.git',
        targetRevision: 'HEAD',
        path: 'clusters/k3s-master/vault',
        plugin: { env: [{ name: 'PLUGIN', value: 'jsonnet-helm-with-crds' }] },
      },
      destination: {
        server: 'https://kubernetes.default.svc',  // in-cluster
        namespace: 'vault',
      },
      syncPolicy: { syncOptions: ['CreateNamespace=true'] },
    },
  },
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'k3s-master-harbor',
      namespace: 'argocd',
      labels: { app: 'argocd', cluster: 'k3s-master' },
    },
    spec: {
      project: 'platform',
      source: {
        repoURL: 'https://github.com/belajarpowershell/k3s-repository.git',
        targetRevision: 'HEAD',
        path: 'clusters/k3s-master/harbor',
        plugin: { env: [{ name: 'PLUGIN', value: 'jsonnet-helm-with-crds' }] },
      },
      destination: {
        server: 'https://kubernetes.default.svc',  // in-cluster
        namespace: 'harbor',
      },
      syncPolicy: { syncOptions: ['CreateNamespace=true'] },
    },
  },
];

// Apps for remote clusters (no ArgoCD)
// Here this is a function, that is created for each cluster 
local remoteApps = function(cluster) [
  // cert-manager
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: cluster + '-cert-manager',
      namespace: 'argocd',
      labels: { app: 'cert-manager', cluster: cluster },
    },
    spec: {
      project: 'platform',
      source: {
        repoURL: 'https://github.com/belajarpowershell/k3s-repository.git',
        targetRevision: 'HEAD',
        path: 'clusters/' + cluster + '/cert-manager',
        plugin: { env: [{ name: 'PLUGIN', value: 'jsonnet-helm-with-crds' }] },
      },
      destination: {
        name: cluster,
        namespace: 'cert-manager',
      },
      syncPolicy: { syncOptions: ['CreateNamespace=true'] },
    },
  },

  // ingress-nginx
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: cluster + '-ingress-nginx',
      namespace: 'argocd',
      labels: { app: 'ingress-nginx', cluster: cluster },
    },
    spec: {
      project: 'platform',
      source: {
        repoURL: 'https://github.com/belajarpowershell/k3s-repository.git',
        targetRevision: 'HEAD',
        path: 'clusters/' + cluster + '/ingress-nginx',
        plugin: { env: [{ name: 'PLUGIN', value: 'jsonnet-helm' }] },
      },
      destination: {
        name: cluster,
        namespace: 'ingress-nginx',
      },
      syncPolicy: { automated: {}, syncOptions: ['CreateNamespace=true'] },
    },
  }
];



// here the for each cluster in clusters loop is performed 
// and then merged with the static ArgoCD deployment.
masterApps + [app for cluster in clusters for app in remoteApps(cluster)]

// Flatten everything 
// global-app-of-apps.jsonnet | kubectl apply -f -
