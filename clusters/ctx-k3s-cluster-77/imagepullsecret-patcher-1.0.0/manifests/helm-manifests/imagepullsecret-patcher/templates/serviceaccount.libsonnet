{
  apiVersion: 'v1',
  kind: 'ServiceAccount',
  metadata: {
    name: 'imagepullsecret-patcher',
    labels: {
      'helm.sh/chart': 'imagepullsecret-patcher-1.0.0',
      'app.kubernetes.io/name': 'imagepullsecret-patcher',
      'app.kubernetes.io/instance': 'imagepullsecret-patcher',
      'app.kubernetes.io/version': '0.14',
      'app.kubernetes.io/managed-by': 'Helm',
    },
  },
}
