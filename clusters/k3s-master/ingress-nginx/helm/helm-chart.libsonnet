# Import Parameters
local chart = import '../../../../libs/ingress-nginx/ingress-nginx.jsonnet';
local config = import '../../cluster.jsonnet';

# Create config variables populated
chart(config)


# to apply this helm chart manually, run:
# kubectl apply -f <(jsonnet k3s-master/ingress-nginx/helm/helm-chart.libsonnet)