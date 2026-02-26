#local chart = import '../../libs/argo-cd-8.6.4/chart.libsonnet';
local chart = import '../../libs/argo-cd-9.4.3/chart.libsonnet';

local p = import 'params.libsonnet';

chart.HelmDefinition(p) {}