local clusters = [
  'k3s-master',
  'k3s-01',
  'k3s-02',
  'k3s-03',
];

// Apps for k3s-master (ArgoCD + cert-manager + ingress-nginx)
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
      syncPolicy: { automated: {}, syncOptions: ['CreateNamespace=true'] },
    },
  },

  // cert-manager
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'k3s-master-cert-manager',
      namespace: 'argocd',
      labels: { app: 'cert-manager', cluster: 'k3s-master' },
    },
    spec: {
      project: 'platform',
      source: {
        repoURL: 'https://github.com/belajarpowershell/k3s-repository.git',
        targetRevision: 'HEAD',
        path: 'clusters/k3s-master/cert-manager',
        plugin: { env: [{ name: 'PLUGIN', value: 'jsonnet-helm-with-crds' }] },
      },
      destination: {
        server: 'https://kubernetes.default.svc',
        namespace: 'cert-manager',
      },
      syncPolicy: { automated: {}, syncOptions: ['CreateNamespace=true'] },
    },
  },

  // ingress-nginx
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'k3s-master-ingress-nginx',
      namespace: 'argocd',
      labels: { app: 'ingress-nginx', cluster: 'k3s-master' },
    },
    spec: {
      project: 'platform',
      source: {
        repoURL: 'https://github.com/belajarpowershell/k3s-repository.git',
        targetRevision: 'HEAD',
        path: 'clusters/k3s-master/ingress-nginx',
        plugin: { env: [{ name: 'PLUGIN', value: 'jsonnet-helm' }] },
      },
      destination: {
        server: 'https://kubernetes.default.svc',
        namespace: 'ingress-nginx',
      },
      syncPolicy: { automated: {}, syncOptions: ['CreateNamespace=true'] },
    },
  }
];

// Apps for remote clusters (no ArgoCD)
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
      syncPolicy: { automated: {}, syncOptions: ['CreateNamespace=true'] },
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



// Flatten everything
masterApps + [app for cluster in clusters for app in remoteApps(cluster)]