local chart = import '../../../libs/imagepullsecret-patcher-1.0.0/chart.libsonnet';
local p = import '../params.libsonnet';
local overrides = import 'overrides.libsonnet';

chart.HelmDefinition(p) {
  'values.yaml'+: overrides
}
