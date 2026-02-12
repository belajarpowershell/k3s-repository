local chart = import '../../../../libs/cert-manager/cert-manager.jsonnet';
local config = import '../../cluster.libsonnet';

# Create config variables populated
chart(config)


# to apply this helm chart manually, run:
# kubectl apply -f <(jsonnet k3s-master/cert-manager/helm/helm-chart.libsonnet)
