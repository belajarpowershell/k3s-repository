{
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    labels: {
      'helm.sh/chart': 'imagepullsecret-patcher-1.0.0',
      'app.kubernetes.io/name': 'imagepullsecret-patcher',
      'app.kubernetes.io/instance': 'imagepullsecret-patcher',
      'app.kubernetes.io/version': '0.14',
      'app.kubernetes.io/managed-by': 'Helm',
    },
    name: 'imagepullsecret-patcher',
  },
  rules: [
    {
      apiGroups: [
        '',
      ],
      resources: [
        'secrets',
        'serviceaccounts',
      ],
      verbs: [
        'list',
        'secrets',
        'serviceaccounts',
        'patch',
        'create',
        'get',
        'delete',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resources: [
        'namespaces',
      ],
      verbs: [
        'list',
        'get',
      ],
    },
  ],
}
{
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRoleBinding',
  metadata: {
    labels: {
      'helm.sh/chart': 'imagepullsecret-patcher-1.0.0',
      'app.kubernetes.io/name': 'imagepullsecret-patcher',
      'app.kubernetes.io/instance': 'imagepullsecret-patcher',
      'app.kubernetes.io/version': '0.14',
      'app.kubernetes.io/managed-by': 'Helm',
    },
    name: 'imagepullsecret-patcher',
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'imagepullsecret-patcher',
  },
  subjects: [
    {
      kind: 'ServiceAccount',
      name: 'imagepullsecret-patcher',
      namespace: 'imagepullsecret-patcher',
    },
  ],
}
