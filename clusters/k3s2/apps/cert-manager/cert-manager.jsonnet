
// Import cluster settings
local config = import "../../../k3s2/cluster.jsonnet";  // Define config

// Import the cert-manager template and pass config
local certManagerApp = import "../../../libs/cert-manager/cert-manager.jsonnet";

certManagerApp(config)  // Call the function with config
