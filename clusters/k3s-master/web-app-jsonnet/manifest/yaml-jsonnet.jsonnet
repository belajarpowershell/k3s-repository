local webapp = import '../../../../libs/web-app-jsonnet/web-app-generic.libsonnet';
local config = import '../config.jsonnet';
#local config = import '../../cluster.jsonnet';

# Create config variables populated
webapp.app(config)