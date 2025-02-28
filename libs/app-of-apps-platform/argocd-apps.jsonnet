local app(name, repoPath, namespace='argocd') = {
  apiVersion: "argoproj.io/v1alpha1",
  kind: "Application",
  metadata: {
    name: name,
    namespace: namespace,
  },
  spec: {
    project: "default",
    source: {
      repoURL: "https://github.com/belajarpowershell/k3s-repository.git",
      targetRevision: "main",
      path: k3s1/apps,
    },
    destination: {
      server: "https://kubernetes.default.svc",
      namespace: namespace,
    },
  },
};

{
  apiVersion: "argoproj.io/v1alpha1",
  kind: "List",
  items: [
    app("argocd", "libs/argocd"),
    app("cert-manager", "libs/cert-manager"),
    app("ingress-nginx", "libs/ingress-nginx"),

  ],
}
