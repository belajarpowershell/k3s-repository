// // global-root.jsonnet
// local global = import 'global-app-of-apps.libsonnet';

// global

{
  apiVersion: "argoproj.io/v1alpha1",
  kind: "Application",
  metadata: {
    name: "global-app-of-apps",
    namespace: "argocd",
  },
  spec: {
    project: "default",
    source: {
      repoURL: "https://github.com/belajarpowershell/k3s-repository.git",
      targetRevision: "HEAD",
      path: "platform/",
    },
    destination: {
      server: "https://kubernetes.default.svc",
      namespace: "argocd",
    },
    syncPolicy: {
      // automated: {
      //   prune: true,
      //   selfHeal: true,
      // },
    },
  },
}