// local globals = import '../globals.libsonnet';
// local kube = import '../kube.libsonnet';
// local kubeExt = import '../kubeExtensions.libsonnet';

{
  Customizations(p):: {
    extraDeploy+:[
      {
        // apiVersion: 'metallb.io/v1beta1',
        // kind: 'IPAddressPool',
        // metadata:{
        //     name: 'default',
        //     namespace: 'metallb-system'
        // },
        // spec:{
        //   addresses:[
        //     p.metallb.addresses
        //   ],
        // },
      },
      
    ],
  }
}