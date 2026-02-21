// nginx-app.libsonnet
// Jsonnet for Deployment + Service + Ingress

{
  deployment: {
    apiVersion: "apps/v1",
    kind: "Deployment",
    metadata: {
      name: "nginx-deployment",
      namespace: "default",
    },
    spec: {
      replicas: 2,
      selector: {
        matchLabels: {
          app: "nginx",
        },
      },
      template: {
        metadata: {
          labels: {
            app: "nginx",
          },
        },
        spec: {
          containers: [
            {
              name: "nginx",
              image: "nginx:1.25",
              ports: [
                {
                  containerPort: 80,
                }
              ],
            }
          ],
        },
      },
    },
  },

  service: {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      name: "nginx-service",
      namespace: "default",
    },
    spec: {
      selector: {
        app: "nginx",
      },
      type: "ClusterIP",
      ports: [
        {
          protocol: "TCP",
          port: 80,
          targetPort: 80,
        }
      ],
    },
  },

  ingress: {
    apiVersion: "networking.k8s.io/v1",
    kind: "Ingress",
    metadata: {
      name: "nginx-ingress",
      namespace: "default",
    },
    spec: {
      ingressClassName: "nginx",
      rules: [
        {
          host: "webapp-master.k8s.lab",
          http: {
            paths: [
              {
                path: "/",
                pathType: "Prefix",
                backend: {
                  service: {
                    name: "nginx-service",
                    port: {
                      number: 80,
                    },
                  },
                },
              }
            ],
          },
        }
      ],
    },
  }
}
