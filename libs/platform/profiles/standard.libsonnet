local template = import "../templates/application.libsonnet";

local ingress = import "../definitions/ingress-nginx.libsonnet";
local cert = import "../definitions/cert-manager.libsonnet";

function(cluster)
[
  template(ingress + { cluster: cluster }),
  template(cert + { cluster: cluster }),
]
