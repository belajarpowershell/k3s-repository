// cert-manager.jsonnet (in libs/cert-manager)
local certManagerApp = function(config){  // Accept config as a parameter
  apiVersion: "argoproj.io/v1alpha1",
  kind: "Application",
  metadata: {
    name: "cert-manager",
    namespace: "argocd",
  },
  spec: {
    destination: {
      server: "https://" + config.clusterName + ":6443",  // Use the passed config
      namespace: "cert-manager",
    },
    project: "platform-component",
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
};

// Export the function
certManagerApp
