// local globals = import '../globals.libsonnet';
// local kube = import '../kube.libsonnet';
// local kubeExt = import '../kubeExtensions.libsonnet';

{
  Customizations(p):: {

    
      image: {
        repository: 'quay.io/titansoft/imagepullsecret-patcher',
        pullPolicy: 'IfNotPresent',
        tag: 'v0.14',
      },
      conf: {
        force: true,
        debug: false,
        runone: false,
        managedonly: false,
        service_accounts: [],
        all_service_accounts: true,
        excluded_namespaces: [],
        interval: '10',
        secretName: 's-test',
      },
      imagePullSecrets: [],
      nameOverride: '',
      fullnameOverride: 'imagepullsecret-patcher',
      serviceAccount: {
        create: true,
        annotations: {},
        name: '',
      },
      podAnnotations: {},
      podSecurityContext: {},
      securityContext: {},
      nodeSelector: {},
      tolerations: [],
      affinity: {},
    

  },
 
  
}