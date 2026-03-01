local chart = import '../../../libs/harbor-1.18.1/chart.libsonnet';
local config = import '../cluster.libsonnet';
local p = import '../params.libsonnet';




# Create config variables populated
#chart(config)
 
chart.HelmDefinition(p) {}

# to apply this helm chart manually, run:
## Cannot run this command for jsonnet helm manifest
# kubectl apply -f <(jsonnet k3s-master/ingress-nginx/helm/helm-chart.libsonnet)

