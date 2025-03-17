local config = import "../../../libs/cluster-secrets/cluster-secret.jsonnet";
local clusters = import "../../../libs/cluster-secrets/remote/clusters.json";

// Generate a list of Secrets for all clusters
{
  "apiVersion": "v1",
  "kind": "List",
  "items": [config(cluster) for cluster in clusters]
}