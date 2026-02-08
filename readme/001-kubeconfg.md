# Update KUBECONFIG

```bash
export KUBECONFIG=$(for YAML in $(find ${HOME}/.kube/clusters -name '*.yaml') ; do echo -n ":${YAML}"; done)

```
