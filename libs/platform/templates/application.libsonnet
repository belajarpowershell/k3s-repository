// Generic ArgoCD Application template

function(params)
{
  apiVersion: "argoproj.io/v1alpha1",
  kind: "Application",

  metadata: {
    name: params.name,
    namespace: "argocd",
  },

  spec: {
    project: params.project,

    destination: {
      name: params.cluster,
      namespace: params.namespace,
    },

    source: params.source,

    syncPolicy: {
      automated: {
        prune: true,
        selfHeal: true,
      },
      syncOptions: ["CreateNamespace=true"],
    },
  },
}
