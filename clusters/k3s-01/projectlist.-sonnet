{
  clusterName: "k3s-01.k8s.lab",
  argocdapplicationprefix: "k3s-01",
  projects: [
    {
      name: "project-demo1",
      description: "Project for managing platform applications",
      sourceRepos: ["https://github.com/belajarpowershell/k3s-repository.git"],
      destinations: [{ namespace: "*", server: "*" }],
      clusterResourceWhitelist: [{ group: "*", kind: "*" }],
      namespaceResourceWhitelist: [{ group: "*", kind: "*" }]
    },
    {
      name: "project-demo2",
      description: "Project for another app",
      sourceRepos: ["https://github.com/example/repo.git"],
      destinations: [{ namespace: "default", server: "*" }],
      clusterResourceWhitelist: [{ group: "apps", kind: "Deployment" }],
      namespaceResourceWhitelist: [{ group: "*", kind: "*" }]
    }
  ]
}