
{
  name: 'ctx-k3s-cluster-77',
  uri: 'argocd.k8s.lab',
  policy: importstr 'policy.csv',
  region: 'sea',
  environment: 'prd',
  repositories: {
    'k8s-cluster-configuration': {
      url: 'https://github.com/belajarpowershell/k3s-repository.git', 
    },
  },
  timeZone: 'America/Argentina/Buenos_Aires'
}
