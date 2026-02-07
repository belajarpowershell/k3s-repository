local plugins = import 'lib/argocd/cmp-plugins.libsonnet';

{
  dex: { enabled: false },
  notifications: { enabled: false },
  applicationSet: { enabled: true },

  server: {
    insecure: true,
    extraArgs: ['--insecure'],
    ingress: {
      enabled: true,
      hosts: ['argocd-master.k8s.lab'],
      ingressClassName: 'nginx',
    },
  },

  global: { domain: 'k8s.lab' },

  configs: {
    cm: { 'exec.enabled': 'true' },
  },

  repoServer: {
    volumes: [
      { name: 'custom-tools', emptyDir: {} },
      { name: 'jsonnet-helm-plugin', configMap: { name: 'jsonnet-helm' } },
      { name: 'jsonnet-helm-with-crds-plugin', configMap: { name: 'jsonnet-helm-with-crds' } },
    ],

    volumeMounts: [
      { name: 'custom-tools', mountPath: '/custom-tools' },
      {
        name: 'jsonnet-helm-plugin',
        mountPath: '/home/argocd/cmp-server/config/jsonnet-helm.yaml',
        subPath: 'plugin.yaml',
      },
      {
        name: 'jsonnet-helm-with-crds-plugin',
        mountPath: '/home/argocd/cmp-server/config/jsonnet-helm-with-crds.yaml',
        subPath: 'plugin.yaml',
      },
    ],

    initContainers: [
      {
        name: 'install-jsonnet',
        image: 'alpine:3.19',
        command: ['sh','-c'],
        args: [
          'wget -qO- https://github.com/google/jsonnet/releases/download/v0.17.0/jsonnet-bin-v0.17.0-linux.tar.gz | tar -xvzf - && mv jsonnet /custom-tools/',
        ],
        volumeMounts: [{ name: 'custom-tools', mountPath: '/custom-tools' }],
      },
    ],

    env: [
      {
        name: 'PATH',
        value: '/custom-tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      },
    ],
  },

  // 👇 This is the magic
  extraObjects: plugins,
}
