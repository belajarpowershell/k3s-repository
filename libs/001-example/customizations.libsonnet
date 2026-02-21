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