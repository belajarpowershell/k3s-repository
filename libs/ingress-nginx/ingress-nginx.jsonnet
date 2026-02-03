// ingress-nginx.jsonnet (in libs/ingress-nginx)
local application = function(config){  // Accept config as a parameter
  apiVersion: "argoproj.io/v1alpha1",
  kind: "Application",
  metadata: {
    name: config.argocdapplicationprefix +"-" +"ingress-nginx",
    namespace: "argocd",
  },
  spec: {
    destination: {
      server: config.clusterName + ":6443",  // Use the passed config
      namespace: "ingress-nginx",
    },
    project: "default",
    source: {
      chart: "ingress-nginx",
      repoURL: "https://kubernetes.github.io/ingress-nginx",
      targetRevision: "4.10.0",
    },
    // syncPolicy: {
    //   automated: {
    //     prune: true,
    //     selfHeal: true,
    //   },
    //   syncOptions: ["CreateNamespace=true"],
    // },
  },
};

// Export the function
application
