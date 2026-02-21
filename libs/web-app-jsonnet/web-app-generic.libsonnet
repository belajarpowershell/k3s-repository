// Generic Web App (Deployment + Service + Ingress)
// Accepts a single config object
{
  app(cfg):: [

    // -----------------------
    // Deployment
    // -----------------------
    {
      apiVersion: "apps/v1",
      kind: "Deployment",
      metadata: {
        name: cfg.name,
        namespace: cfg.namespace,
        labels: {
          app: cfg.name,
        },
      },
      spec: {
        replicas: cfg.replicas,
        selector: {
          matchLabels: {
            app: cfg.name,
          },
        },
        template: {
          metadata: {
            labels: {
              app: cfg.name,
            },
          },
          spec: {
            containers: [
              {
                name: cfg.name,
                image: cfg.image,
                ports: [
                  {
                    containerPort: cfg.containerPort,
                  },
                ],
              },
            ],
          },
        },
      },
    },

    // -----------------------
    // Service
    // -----------------------
    {
      apiVersion: "v1",
      kind: "Service",
      metadata: {
        name: cfg.name,
        namespace: cfg.namespace,
      },
      spec: {
        selector: {
          app: cfg.name,
        },
        ports: [
          {
            port: cfg.servicePort,
            targetPort: cfg.containerPort,
          },
        ],
      },
    },

    // -----------------------
    // Ingress
    // -----------------------
    {
      apiVersion: "networking.k8s.io/v1",
      kind: "Ingress",
      metadata: {
        name: cfg.name,
        namespace: cfg.namespace,
      },
      spec: {
        ingressClassName: cfg.ingressClass,
        rules: [
          {
            host: cfg.host,
            http: {
              paths: [
                {
                  path: "/",
                  pathType: "Prefix",
                  backend: {
                    service: {
                      name: cfg.name,
                      port: {
                        number: cfg.servicePort,
                      },
                    },
                  },
                },
              ],
            },
          },
        ],
      },
    },
  ],
}
