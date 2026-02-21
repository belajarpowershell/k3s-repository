{
  name: "ingress-nginx",
  namespace: "ingress-nginx",
  project: "platform",

  source: {
    repoURL: "https://kubernetes.github.io/ingress-nginx",
    chart: "ingress-nginx",
    targetRevision: "4.10.0",
    helm: {
      releaseName: "ingress-nginx",
    },
  },
}
