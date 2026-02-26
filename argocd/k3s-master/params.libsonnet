local globals = import '../../libs/globals.libsonnet';

{
  name: 'k3s-master',
  domain: 'k8s.lab',
  hostname: 'k3s-master',
  policy: importstr 'policy.csv',
  region: 'az1',
  environment: 'dev',
  repositories: {
    'k8s-cluster-configuration': {
      url: 'https://github.com/belajarpowershell/k3s-repository.git',      
    },
  },
}
