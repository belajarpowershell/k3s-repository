local globals = import '../../libs/globals.libsonnet';

{
  name: 'k3s-master',
  domain: 'k8s.lab',
  hostname: 'k3s-master',
  #uri: 'argocd.dev.ar85b.skf.io',
  policy: importstr 'policy.csv',
  region: 'az1',
  environment: 'dev',
  repositories: {
    'k8s-cluster-configuration': {
      url: 'git@ssh.dev.azure.com:v3/skf-digital-manufacturing/SKF-DP-WCM%20Infrastructure/k8s-cluster-configuration',      
    },
  },
  timeZone: 'America/Argentina/Buenos_Aires'
}
