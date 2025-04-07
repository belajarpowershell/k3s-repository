local plugins = import "../../../libs/argocd/plugins.jsonnet";

[
  plugins.jsonnetHelmWithCrds,
  plugins.jsonnetHelm
]
