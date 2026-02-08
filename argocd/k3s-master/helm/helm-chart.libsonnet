local chart = import '../../../libs/argo-cd-5.26.0/chart.libsonnet';
local p = import '../params.libsonnet';

chart.HelmDefinition(p) {}