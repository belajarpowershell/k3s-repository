## Updated 8 Feb 2026- Suresh
# This generates ArgoCD to deploy with volume mounts for
#  custom-tools , jsonnet-helm-plugin ,jsonnet-helm-with-crds-plugin

{
   Customizations(p):: {
# Customizations for ArgoCD
# Specific configurations that are different from the default installations
# are defined here. This is a good place to put customizations that are
# specific to your environment.
    fullnameOverride: 'argocd',
    dex+: {
      enabled: false,
    },
    applicationSet+: {
      enabled: true,
    },
    server+: {
      extraArgs: [
        '--insecure',
      ],
      ingress+: {
        enabled: true,
        ingressClassName: 'nginx',
        hostname: p.hostname,
        domain: p.domain,
        https: false,
      },
      insecure+: true

    },
    configs+: {
      secret: {
        argocdServerAdminPassword: '$2b$12$3peDOQrx3EVLpfCJ.lRQQOSVNBiyjbJ0ofT79qrsdJvU9eTBG.mFm',
        argocdServerAdminPasswordMtime: "$(date +%FT%T%Z)",

      },
      cm: { 
        'exec.enabled': "true"
      }
    },
    repoServer+: {
      env+: [    
        {
          name: 'PATH',
          value: '/custom-tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        }
      ], 
      volumeMounts: [
        {
          # same as initContainer so jsonnet is visible in repo-server container
          name: 'custom-tools',
          mountPath: '/custom-tools',
        },
        {
          name: 'jsonnet-helm-plugin',
          mountPath: '/home/argocd/cmp-server/config/jsonnet-helm-plugin.yaml',
          subPath: 'plugin.yaml',
        },
        {
          name: 'jsonnet-helm-with-crds-plugin',
          mountPath: '/home/argocd/cmp-server/config/jsonnet-helm-with-crds-plugin.yaml',
          subPath: 'plugin.yaml',
        },
      ],
      initContainers: [
        {
          name: 'install-jsonnet-helm',
          args: [
            'wget -qO- https://github.com/google/jsonnet/releases/download/v0.17.0/jsonnet-bin-v0.17.0-linux.tar.gz | tar -xvzf - && mv jsonnet /custom-tools/',
          ],
          command: [
            'sh',
            '-c',
          ],
          image: 'alpine:3.19',
          volumeMounts: [
            {
            #  this volume is in initContainer
              mountPath: '/custom-tools',
              name: 'custom-tools',
            },
          ],
        },
      ],
      volumes: [
        {
          name: 'custom-tools',
          emptyDir: {},
        },
        {
          configMap: {
            name: 'jsonnet-helm-with-crds-plugin',
          },
          name: 'jsonnet-helm-with-crds-plugin',
        },
        {
          configMap: {
            name: 'jsonnet-helm-plugin',
          },
          name: 'jsonnet-helm-plugin',
        },
      ],
      extraContainers: [
        // {
        //   name: 'jsonnet-helm-with-crds',
        //   command: [
        //     '/var/run/argocd/argocd-cmp-server',
        //   ],
        //   image: 'quay.io/argoproj/argocd:v2.9.0',
        //   securityContext: {
        //     runAsNonRoot: true,
        //     runAsUser: 999,
        //   },
        //   volumeMounts: [
        //     {
        //       mountPath: '/var/run/argocd',
        //       name: 'var-files',
        //     },
        //     {
        //       mountPath: '/home/argocd/cmp-server/plugins',
        //       name: 'plugins',
        //     },
        //     {
        //       mountPath: '/home/argocd/cmp-server/config/plugin.yaml',
        //       subPath: 'plugin.yaml',
        //       name: 'jsonnet-helm-with-crds',
        //     },
        //     {
        //       mountPath: '/tmp',
        //       name: 'cmp-tmp',
        //     },
        //     {
        //       name: 'custom-tools',
        //       mountPath: '/usr/bin/jsonnet',
        //       subPath: 'jsonnet',
        //     },
        //   ],
        // },
        // {
        //   name: 'jsonnet-helm',
        //   command: [
        //     '/var/run/argocd/argocd-cmp-server',
        //   ],
        //   image: 'quay.io/argoproj/argocd:v2.9.0',
        //   securityContext: {
        //     runAsNonRoot: true,
        //     runAsUser: 999,
        //   },
        //   volumeMounts: [
        //     {
        //       mountPath: '/var/run/argocd',
        //       name: 'var-files',
        //     },
        //     {
        //       mountPath: '/home/argocd/cmp-server/plugins',
        //       name: 'plugins',
        //     },
        //     {
        //       mountPath: '/home/argocd/cmp-server/config/plugin.yaml',
        //       subPath: 'plugin.yaml',
        //       name: 'jsonnet-helm',
        //     },
        //     {
        //       mountPath: '/tmp',
        //       name: 'cmp-tmp',
        //     },
        //     {
        //       name: 'custom-tools',
        //       mountPath: '/usr/bin/jsonnet',
        //       subPath: 'jsonnet',
        //     },
        //   ],
        // },
      ],
    },
   }
   
}