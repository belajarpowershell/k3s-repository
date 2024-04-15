// {
//   apiVersion: 'v2',
//   appVersion: '0.14',
//   description: 'A Helm chart for imagepullsecret-patcher',
//   home: 'https://github.com/titansoft-pte-ltd/imagepullsecret-patcher',
//   maintainers: [
//     {
//       email: 'ops@empathy.co',
//       name: 'Empathy Platform Team',
//     },
//   ],
//   name: 'imagepullsecret-patcher',
//   sources: [
//     'https://github.com/titansoft-pte-ltd/imagepullsecret-patcher',
//   ],
//   type: 'application',
//   version: '1.0.0',
// }

local p = import 'parameters.json';
local c = import 'customizations.libsonnet';
local defaultValues = import 'values.libsonnet';

local name = p.name;
local chartRepository = p.repository;
local chartVersion = p.version;

{
  HelmDefinition(p):: {
    'Chart.yaml': {
      name: name,
      apiVersion: 'v2',
      version: '1.0.0',
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
