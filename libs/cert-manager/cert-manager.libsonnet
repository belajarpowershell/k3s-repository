// cert-manager.jsonnet (in libs/cert-manager)
local certManagerApp = function(config){  // Accept config as a parameter
local argoappname =  if config.clustertype == "aks" 
          then config.argocdapplicationprefix + "-" + config.clustertype + "-cert-manager"
          else config.argocdapplicationprefix + "-cert-manager",
  apiVersion: "argoproj.io/v1alpha1",
  kind: "Application",
  metadata: {
    #name: config.argocdapplicationprefix + "-" + "cert-manager",
    name: argoappname ,
    namespace: "argocd",
  },
  spec: {
    destination: {
      server: config.clusterName ,  // Use the passed config
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
};

// Export the function
certManagerApp
