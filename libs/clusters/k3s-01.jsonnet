// libs/clusters/k3s-02.jsonnet
local clusterName = "k3s-01";
local kubeconfig = importstr "k3s-01.kubeconfig";  // raw kubeconfig content

{
  apiVersion: "v1",
  kind: "Secret",
  metadata: {
    name: clusterName,
    namespace: "argocd",
    labels: {
      "argocd.argoproj.io/secret-type": "cluster",
    },
  },
  type: "Opaque",
  stringData: {
    name: clusterName,
    server: "https://192.168.100.194:6443",  // set your API endpoint
    config: kubeconfig,
  },
}
