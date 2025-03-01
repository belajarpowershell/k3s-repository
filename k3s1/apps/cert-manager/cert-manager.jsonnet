// Import cluster settings
#local config = import "../../cluster.jsonnet";
local config = import "../../k3s1/cluster.jsonnet";
local certManagerApp = import "../../libs/cert-manager/cert-manager.jsonnet";

certManagerApp  // This will output the exact JSON/YAML structure
