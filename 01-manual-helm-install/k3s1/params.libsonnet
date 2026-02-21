{
  name: 'k3s1',
  hostname: 'argocd1',
  domain: 'k8s.lab',
  policy: importstr 'policy.csv',
  repositories: {
    'k3s-repository': {
      url: 'https://github.com/belajarpowershell/k3s-repository.git',
    },
  },
}