local project = function(config) {
  apiVersion: "argoproj.io/v1alpha1",
  kind: "AppProject",
  metadata: {
    name: config.name,  // Ensure "name" matches projectlist.jsonnet
    namespace: "argocd",
  },
  spec: {
    description: config.description,
    sourceRepos: config.sourceRepos,
    destinations: config.destinations,
    clusterResourceWhitelist: config.clusterResourceWhitelist,
    namespaceResourceWhitelist: config.namespaceResourceWhitelist,
  }
};

// Export the function
project
