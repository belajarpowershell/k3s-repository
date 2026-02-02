// Import cluster settings
local config = import "../../../k3s2/cluster.jsonnet";  // Define config

// Import the ingress-nginx template and pass config
local application = import "../../../libs/ingress-nginx/ingress-nginx.jsonnet";

application(config)  // Call the function with config
