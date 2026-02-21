#local globals = import '../globals.libsonnet';

local p = import 'parameters.json';
local c = import 'customizations.libsonnet';
local defaultValues = import 'values.libsonnet';

local name = p.name;
local chartRepository = p.repository;
local chartVersion = p.version;
local extras = import 'extras.libsonnet';

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
