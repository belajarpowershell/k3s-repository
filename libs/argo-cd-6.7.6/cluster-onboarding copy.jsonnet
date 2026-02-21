// libs/argo-cd-6.7.6/cluster-onboarding.jsonnet

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
    data: {
      # Name of the cluster for ArgoCD UI
      name: std.base64(c.name),
      server: std.base64(c.server),
      # The kubeconfig itself
      config: std.base64(
        std.toString({
          apiVersion: "v1",
          kind: "Config",
          clusters: [
            {
              name: c.name,
              cluster: {
                server: c.server,
                # For self-signed k3s certs, skip verification
                "insecure-skip-tls-verify": true,
                # Or use CA if you want verification
                // "certificate-authority-data": c.tlsClientConfig.caData,
              },
            },
          ],
          contexts: [
            {
              name: c.name,
              context: {
                cluster: c.name,
                user: c.name + "-admin",
              },
            },
          ],
          "current-context": c.name,
          users: [
            {
              name: c.name + "-admin",
              user: {
                "client-certificate-data": c.tlsClientConfig.certData,
                "client-key-data": c.tlsClientConfig.keyData,
              },
            },
          ],
        })
      ),
    },
  } for c in clusters
]
