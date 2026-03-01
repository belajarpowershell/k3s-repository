{
  Customizations(p):: {
    #installCRDs: true
    server+: {
      enabled: 'true',
      ingress: {
        enabled: true,
        labels: {},
        annotations: {},
        ingressClassName: 'nginx',
        pathType: 'Prefix',
        activeService: true,
        hosts: [
          {
            host: 'vault.k8s.lab',
            paths: [],
          },
        ],
        extraPaths: [],
        tls: [],
      },
      "dev": {
            "devRootToken": "root",
            "enabled": true
      },

    }
  },
}
