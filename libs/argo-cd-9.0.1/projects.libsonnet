[
  {
    "apiVersion": "argoproj.io/v1alpha1",
    "kind": "AppProject",
    "metadata": {
      "name": "platform",
      "namespace": "argocd"
    },
    "spec": {
      "description": "Platform infra",
      "sourceRepos": ["*"],
      "destinations": [
        {
          "namespace": "*",
          "server": "*"
        }
      ],
      "clusterResourceWhitelist": [
        {
          "group": "*",
          "kind": "*"
        }
      ]
    }
  },
  {
    "apiVersion": "argoproj.io/v1alpha1",
    "kind": "AppProject",
    "metadata": {
      "name": "workloads",
      "namespace": "argocd"
    },
    "spec": {
      "description": "Application workloads",
      "sourceRepos": ["*"],
      "destinations": [
        {
          "namespace": "*",
          "server": "*"
        }
      ],
      "clusterResourceWhitelist": [
        {
          "group": "*",
          "kind": "*"
        }
      ]
    }
  }
]
