#local chart = import '../../libs/argo-cd-6.7.6/chart.libsonnet';
#local chart = import '../../libs/argo-cd-9.0.1/chart.libsonnet';
local chart = import '../../libs/argo-cd-9.4.3/chart.libsonnet';

local p = import 'params.libsonnet';

chart.HelmDefinition(p) {}