local clusters = import '../clusters/remote/clusters.json';

[
  {
    apiVersion: 'v1',
    kind: 'Secret',
    metadata: {
      name: 'cluster-' + c.name,
      namespace: 'argocd',
      labels: {
        'argocd.argoproj.io/secret-type': 'cluster',
      },
    },
    type: 'Opaque',
    stringData: {
      name: c.name,
      server: c.server,
      config: std.toString({
        tlsClientConfig: {
          insecure: true,
          certData: c.tlsClientConfig.certData,
          keyData: c.tlsClientConfig.keyData,
          caData: c.tlsClientConfig.caData,
        },
      }),
    },
  }
  for c in clusters
]
