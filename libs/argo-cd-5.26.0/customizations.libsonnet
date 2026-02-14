
# ArgoCD projects can
local projects = import '../argocd-projects.libsonnet';

# extras contain the configmap to be deployed in argocd.
local extras = import 'extras.libsonnet';

{
  Customizations(p):: {
    fullnameOverride: 'argocd',

    dex+: {
      enabled: false,
    },

    applicationSet+: {
      enabled: true,
    },

    server+: {
      extraArgs+: ['--insecure'],
      ingress+: {
        enabled: true,
        ingressClassName: 'nginx',
        hostname: 'argocd-master', #p.hostname,
        domain: p.domain,
        hosts: [
          'argocd-master.k8s.lab'
#          p.hostname + '.' + p.domain,
        ],
        https: false,
        annotations+: {
#          'nginx.ingress.kubernetes.io/backend-protocol': 'HTTPS',
          'nginx.ingress.kubernetes.io/backend-protocol': 'HTTP',

        },
      },
      insecure+: true,
    },

    configs+: {
      secret: {
        argocdServerAdminPassword: '$2b$12$3peDOQrx3EVLpfCJ.lRQQOSVNBiyjbJ0ofT79qrsdJvU9eTBG.mFm',
        argocdServerAdminPasswordMtime: '$(date +%FT%T%Z)',
      },
      cm: {
        'exec.enabled': 'true',
      },
    },

    repoServer+: {
      // Enable CMP in repo-server
      extraArgs+: [ '--loglevel', 'debug'],

      // Add custom PATH to include sidecar binaries
      env+: [
        {
          name: 'PATH',
          value: '/custom-tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        },
      ],

      // Shared volumes between repo-server and sidecars
      volumes+: [
        {
          name: 'custom-tools',
          emptyDir: {},
        },
        {
          name: 'cmp-tmp',
          emptyDir: {},
        },
        {
          name: 'var-files',
          emptyDir: {},
        },
        {
          name: 'plugins',
          emptyDir: {},
        },
        {
          configMap:
            {
              name: 'jsonnet-helm-plugin',
            },
          name: 'jsonnet-helm-plugin',
        },
        {
          configMap:
            {
              name: 'jsonnet-helm-with-crds-plugin',
            },
          name: 'jsonnet-helm-with-crds-plugin',
        },
      ],

      // Mounts in the repo-server
      volumeMounts+: [
        {
          name: 'custom-tools',
          mountPath: '/custom-tools',
        },
      ],

      // Init container to install jsonnet
      initContainers+: [
        {
          name: 'install-jsonnet',
          image: 'alpine:3.19',
          command: ['sh', '-c'],
          args: [
            'wget -qO- https://github.com/google/jsonnet/releases/download/v0.17.0/jsonnet-bin-v0.17.0-linux.tar.gz | tar -xvzf - && mv jsonnet /custom-tools/',
          ],
          volumeMounts: [
            { name: 'custom-tools', mountPath: '/custom-tools' },
          ],
        },
      ],

      // Sidecar plugin containers
      extraContainers+: [
        {
          name: 'jsonnet-helm-plugin',
          command: ['/var/run/argocd/argocd-cmp-server'],
          #image: 'alpine:3.19',
          image: 'quay.io/argoproj/argocd:v2.9.0',
          securityContext: { runAsNonRoot: true, runAsUser: 999 },
          volumeMounts: [
            {
              name: 'var-files',
              mountPath: '/var/run/argocd',
            },
            {
              name: 'plugins',
              mountPath: '/home/argocd/cmp-server/plugins',
            },
            {
              name: 'jsonnet-helm-plugin',
              mountPath: '/home/argocd/cmp-server/config/plugin.yaml',
              subPath: 'plugin.yaml',
            },
            {
              name: 'cmp-tmp',
              mountPath: '/tmp',
            },
            {
              name: 'custom-tools',
              mountPath: '/custom-tools',
            },
          ],
        },
        {
          name: 'jsonnet-helm-with-crds-plugin',
          command: ['/var/run/argocd/argocd-cmp-server'],
          #image: 'alpine:3.19',
          image: 'quay.io/argoproj/argocd:v2.9.0',
          securityContext: { runAsNonRoot: true, runAsUser: 999 },
          volumeMounts: [
            {
              name: 'var-files',
              mountPath: '/var/run/argocd',
            },
            {
              name: 'plugins',
              mountPath: '/home/argocd/cmp-server/plugins',
            },
            {
              name: 'jsonnet-helm-with-crds-plugin',
              mountPath: '/home/argocd/cmp-server/config/plugin.yaml',
              subPath: 'plugin.yaml',
            },
            {
              name: 'cmp-tmp',
              mountPath: '/tmp',
            },
            {
              name: 'custom-tools',
              mountPath: '/custom-tools',
            },
          ],
        },
      ],
    },

    extraObjects+: [
      extras.JsonnetHelmWithCrdsPlugin(p),
      extras.JsonnetHelmPlugin(p),

    ] 
  }

}