function(cluster)
{
  "apiVersion": "v1",
  "kind": "Secret",
  "metadata": {
    "name": "cluster-secret-" + cluster.name,
    "namespace": "argocd",
    "labels": {
      "argocd.argoproj.io/secret-type": "cluster"
    }
  },
  "type": "Opaque",
   "data": {
     "name": cluster.name,
     "server": cluster.server,
    "config": (
      std.manifestJson({
        "tlsClientConfig": {
          "insecure": cluster.tlsClientConfig.insecure,
          "caData": cluster.tlsClientConfig.caData,
          "certData": cluster.tlsClientConfig.certData,
          "keyData": cluster.tlsClientConfig.keyData
        }
      })
    )

   }
}
