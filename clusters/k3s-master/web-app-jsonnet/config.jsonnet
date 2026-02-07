
{
  name: "webapp-jsonnet",
  namespace: "webapp-jsonnet",

  image: "nginx:1.25",
  replicas: 1,

  containerPort: 80,
  servicePort: 80,

  host: "webapp-master.k8s.lab",
  ingressClass: "nginx",
}
