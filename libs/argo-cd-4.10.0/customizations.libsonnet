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
      ingress: {
        enabled: true,
        ingressClassName: 'nginx',
        hostname: p.hostname,
        domain: p.domain,
        tls: true,
      },
    },
    configs+: {
      secrets: {
        argocdServerAdminPassword: '$2b$12$3peDOQrx3EVLpfCJ.lRQQOSVNBiyjbJ0ofT79qrsdJvU9eTBG.mFm',
        argocdServerAdminPasswordMtime: "$(date +%FT%T%Z)",

      },
    },
    repoServer+: {
      autoscaling: {
        enabled: true,
        minReplicas: 2,
      },
      serviceAccount+: {
        create: true,
      },
      metrics+: {
        enabled: true,
        serviceMonitor+: {
          enabled: true,
          additionalLabels: {
            release: p.name + '-prometheus',
          },
        },
      },
      volumeMounts: [
        {
          name: 'custom-tools',
          mountPath: '/usr/local/bin/jsonnet',
          subPath: 'jsonnet',
        },
      ],
      initContainers: [
        {
          name: 'download-tools',
          args: [
            'wget -qO- https://github.com/google/jsonnet/releases/download/v0.17.0/jsonnet-bin-v0.17.0-linux.tar.gz | tar -xvzf - && mv jsonnet /custom-tools/',
          ],
          command: [
            'sh',
            '-c',
          ],
          image: 'alpine:3.8',
          volumeMounts: [
            {
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
            name: 'jsonnet-helm-with-crds',
          },
          name: 'jsonnet-helm-with-crds',
        },
        {
          configMap: {
            name: 'jsonnet-helm',
          },
          name: 'jsonnet-helm',
        },
        {
          emptyDir: {},
          name: 'cmp-tmp',
        },
      ],
      extraContainers: [
        {
          name: 'jsonnet-helm-with-crds',
          command: [
            '/var/run/argocd/argocd-cmp-server',
          ],
          image: 'quay.io/argoproj/argocd:v2.9.0',
          securityContext: {
            runAsNonRoot: true,
            runAsUser: 999,
          },
          volumeMounts: [
            {
              mountPath: '/var/run/argocd',
              name: 'var-files',
            },
            {
              mountPath: '/home/argocd/cmp-server/plugins',
              name: 'plugins',
            },
            {
              mountPath: '/home/argocd/cmp-server/config/plugin.yaml',
              subPath: 'plugin.yaml',
              name: 'jsonnet-helm-with-crds',
            },
            {
              mountPath: '/tmp',
              name: 'cmp-tmp',
            },
            {
              name: 'custom-tools',
              mountPath: '/usr/bin/jsonnet',
              subPath: 'jsonnet',
            },
          ],
        },
        {
          name: 'jsonnet-helm',
          command: [
            '/var/run/argocd/argocd-cmp-server',
          ],
          image: 'quay.io/argoproj/argocd:v2.9.0',
          securityContext: {
            runAsNonRoot: true,
            runAsUser: 999,
          },
          volumeMounts: [
            {
              mountPath: '/var/run/argocd',
              name: 'var-files',
            },
            {
              mountPath: '/home/argocd/cmp-server/plugins',
              name: 'plugins',
            },
            {
              mountPath: '/home/argocd/cmp-server/config/plugin.yaml',
              subPath: 'plugin.yaml',
              name: 'jsonnet-helm',
            },
            {
              mountPath: '/tmp',
              name: 'cmp-tmp',
            },
            {
              name: 'custom-tools',
              mountPath: '/usr/bin/jsonnet',
              subPath: 'jsonnet',
            },
          ],
        },
      ],
    },
   }
   
}