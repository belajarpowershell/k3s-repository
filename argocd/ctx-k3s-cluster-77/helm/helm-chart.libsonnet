local chart = import '../../../libs/argo-cd-6.4.0/chart.libsonnet';
local p = import '../params.libsonnet';

chart.HelmDefinition(p) {}
