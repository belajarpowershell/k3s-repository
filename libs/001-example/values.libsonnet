  {
    namespaceOverride: '',
    commonLabels: {},
    controller: {
      replicaCount: 1,
      minAvailable: 1,
      resources: {
        requests: {
          cpu: '100m',
          memory: '90Mi',
        },
      },
    },
    serviceAccount: {
      create: true,
      name: '',
      automountServiceAccountToken: true,
      annotations: {},
    },

  }
