local chart = import '../../../libs/argo-cd-4.10.0/chart.libsonnet';
local p = import '../params.libsonnet';

chart.HelmDefinition(p) {}