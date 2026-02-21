{
  name: "cert-manager",
  namespace: "cert-manager",
  project: "platform",

  source: {
    repoURL: "https://charts.jetstack.io",
    chart: "cert-manager",
    targetRevision: "v1.14.5",
    helm: {
      releaseName: "cert-manager",
      parameters: [
        {
          name: "installCRDs",
          value: "true",
        },
      ],
    },
  },
}
