local globals = import '../../globals.libsonnet'; # referenced from libs
local defaultValues = import 'values.libsonnet'; # referenced in local chart folder
local c = import 'customizations.libsonnet'; # referenced in local chart folder
local p = import 'parameters.json'; # referenced from cluster folder

local name = p.name;
local chartRepository = p.repository;
local chartVersion = p.version;

{
  HelmDefinition(p):: {
    'Chart.yaml': {
      name: name,
      apiVersion: 'v2',
      version: chartVersion,
      dependencies: [
        {
          name: name,
          repository: chartRepository,
          version: chartVersion,
        },
      ],
    },
    'values.yaml': {
      [name]+: defaultValues + c.Customizations(p),
    },    
  },
}
