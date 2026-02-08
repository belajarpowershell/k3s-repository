
# Observations

## the `namespaceOverride` is overidden with content from `libs/001-example/customizations.libsonnet`

## `libs/001-example/customizations.libsonnet`

can populate values based on conditions. 

```bash

{
  Customizations(p):: {
  local name = if p.name == 'k3s-master' then 'k3s-master-example-001' else 'ddd',
    
    namespaceOverride: name,
    serviceAccount: {
    create: false,
    name: '',
    automountServiceAccountToken: true,
    annotations: {},
    },

    
  },
}
```