# Update KUBECONFIG

To merge multiple kubeconfig files into a single context, use:

```bash
export KUBECONFIG=$(for YAML in $(find ${HOME}/.kube/clusters -name '*.yaml') ; do echo -n ":${YAML}"; done)
```

This finds all `.yaml` files in `~/.kube/clusters` and merges them into the `KUBECONFIG` environment variable.
