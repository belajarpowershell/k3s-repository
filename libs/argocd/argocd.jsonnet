{
  apiVersion: "argoproj.io/v1alpha1",
  kind: "Application",
  metadata: {
    name: "argocd",
    namespace: "argocd",
  },
  spec: {
    project: "default",
    source: {
      repoURL: "https://charts.bitnami.com/bitnami",
      chart: "argo-cd",
      targetRevision: "latest",
      helm: {
        values: |||
          dex:
            enabled: false
          notifications:
            enabled: false
          applicationSet:
            enabled: true
          server:
            ingress:
              enabled: true
              hostname: argocd1.k8s.lab
              ingressClassName: nginx
              annotations:
                nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
            extraArgs:
              - --insecure
            insecure: true
          global:
            domain: argocd.k8s.lab
        |||,
      },
    },
    destination: {
      server: "https://kubernetes.default.svc",
      namespace: "argocd",
    },
    syncPolicy: {
      automated: {},
    },
  },
}
