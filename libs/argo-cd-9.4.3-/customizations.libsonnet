
# ArgoCD projects configuration added to deployment
local projects = import '../argocd-projects.libsonnet';

# extras contain the configmap to be deployed in argocd.
local extras = import 'extras.libsonnet';

# add remote cluster kubeconfig in secrets
local clusterOnboarding = import 'cluster-onboarding.jsonnet';

# Create projects in ArgoCD
local projects = import './projects.libsonnet';

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
        hostname: 'argocd-master.k8s.lab', #p.hostname,
        domain: p.domain,
        hosts: 'argocd-master.k8s.lab',
#          p.hostname + '.' + p.domain,
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
      cm+: {
        create: true,
        'exec.enabled': 'true',
      },
      repositories: p.repositories,
    },

### cp block
    repoServer+: {
      // autoscaling: {
      //   enabled: true,
      //   minReplicas: 2,
      // },
      serviceAccount+: {
        create: true,
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
    extraObjects+: [
      extras.JsonnetHelmWithCrdsPlugin(p),
      extras.JsonnetHelmPlugin(p),
    ]
    # add remote clusters to ArgoCD via CLI
    #+ clusterOnboarding # add create secrets for each k3s ( kubeconfig) in k3s-master
    + projects,
  },
}
