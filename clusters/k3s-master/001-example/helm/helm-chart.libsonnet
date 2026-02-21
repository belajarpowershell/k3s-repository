# Import Parameters
local chart = import '../../../../libs/001-example/Chart.libsonnet';
local config = import '../../cluster.libsonnets';
local p = import '../../params.libsonnet';

# Create config variables populated
#chart(config)
 
chart.HelmDefinition(p) {}
# to apply this helm chart manually, run:
# kubectl apply -f <(jsonnet k3s-master/ingress-nginx/helm/helm-chart.libsonnet)