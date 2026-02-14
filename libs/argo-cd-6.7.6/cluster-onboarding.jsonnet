# inmport kubconfig to 
# add create secrets for each k3s ( kubeconfig) in k3s-master

[
  import '../clusters/k3s-01.jsonnet',
  import '../clusters/k3s-02.jsonnet',
  import '../clusters/k3s-03.jsonnet',
]