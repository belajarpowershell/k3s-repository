local config = import "k3s1/apps/cluster.jsonnet";  // Import cluster name

{
  apiVersion: "argoproj.io/v1alpha1",
  kind: "Application",
  metadata: {
    name: "cert-manager",
    namespace: "argocd",
  },
  spec: {
    destination: {
      server: "https://" + config.clusterName + ":6443",
      namespace: "cert-manager",
    },
    project: "default",
    source: {
      chart: "cert-manager",
      repoURL: "https://charts.jetstack.io",
      targetRevision: "v1.14.4",
      helm: {
        values: |||
          installCRDs: true
        |||,
      },
    },
    syncPolicy: {
      automated: {
        prune: true,
        selfHeal: true,
      },
      syncOptions: ["CreateNamespace=true"],
    },
  },
}
