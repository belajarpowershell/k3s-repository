{
  name: "grafana-operator",
  namespace: "grafana",
  project: "platform",

  source: {
    repoURL: "https://grafana.github.io/helm-charts",
    chart: "grafana-operator",
    targetRevision: "v5.0.0",
  },
}
