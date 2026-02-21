// Example usage of libs/kube.libsonnet
// Render with: jsonnet readme/kube-libsonnet-example.jsonnet

local kube = import '../libs/kube.libsonnet';

local pod = kube.Pod('example-pod') {
  metadata+: { namespace: 'default' },
  spec+: {
    containers_: {
      web: {
        image: 'nginx:1.21',
        ports_: { http: { containerPort: 80 } },
      },
    },
  },
};

local svc = kube.Service('example-svc') {
  metadata+: { namespace: 'default' },
  target_pod:: pod,
};

// Output a simple List with the two objects
kube.List() {
  items_:: {
    pod: pod,
    svc: svc,
  },
}