local clustermgmt = import '../../../libs/clustermanagement.libsonnet';
local apps = import '../../default-apps.jsonnet';
local config = import '../cluster.libsonnet';

local kube = import '../../../libs/kube.libsonnet';

local p = config;

local all = apps.DefaultApplications(p) 
            + apps.MonitoringStack(p) {
              #misc: clustermgmt.App(p, 'misc', 'misc'),
            };

kube.List() { items_+: all }