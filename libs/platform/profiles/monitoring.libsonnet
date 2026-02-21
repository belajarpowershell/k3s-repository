local template = import "../templates/application.libsonnet";

local ingress = import "../definitions/ingress-nginx.libsonnet";
local cert = import "../definitions/cert-manager.libsonnet";
local grafana = import "../definitions/grafana-operator.libsonnet";
local eagle = import "../definitions/kube-eagle.libsonnet";

function(cluster)
[
  template(ingress + { cluster: cluster }),
  template(cert + { cluster: cluster }),
  template(grafana + { cluster: cluster }),
  template(eagle + { cluster: cluster }),
]
