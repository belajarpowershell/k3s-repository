local projects = {
  platform: {
    description: 'Platform infra',
    namespaces: ['*'],
  },

  workloads: {
    description: 'Application workloads',
    namespaces: ['apps', 'backend'],
  },
};

[
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'AppProject',
    metadata: {
      name: name,
      namespace: 'argocd',
    },
    spec: {
      description: projects[name].description,
      sourceRepos: ['https://github.com/belajarpowershell/k3s-repository/*'],
      destinations: [
        {
          namespace: ns,
          server: 'https://kubernetes.default.svc',
        }
        for ns in projects[name].namespaces
      ],
      clusterResourceWhitelist: [
        { group: '*', kind: '*' },
      ],
    },
  }
  for name in std.objectFields(projects)
]
