// {
//   clusterName: "k3s-01.k8s.lab",
//   argocdapplicationprefix: "k3s-01",
//   clustertype: "singlenode"
// }

local profile = import "../../libs/platform/profiles/standard.libsonnet";

profile("k3s-01")
