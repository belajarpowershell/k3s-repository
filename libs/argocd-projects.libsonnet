{}
// local allResources = [
//   {
//     group: '*',
//     kind: '*',
//   },
// ];

// local defaultAdminRole(name, description=null) = {
//   description: if description == null then name + ' Administrator' else description,
//   groups: [
//     name + '-admins',
//   ],
//   name: 'admin',
//   policies: [
//     'p, proj:' + name + ':admin, applications, *, ' + name + '/*, allow',
//   ],
// };

// local defaultProjectTemplate(name, long_name=null) = kube._Object('argoproj.io/v1alpha1', 'AppProject', name) {
//   spec+: {
//     description: name,
//     clusterResourceWhitelist: allResources,
//     destinations: [],  //Must be provided as overrides.
//     roles: [
//       defaultAdminRole(name, long_name),
//     ],  //Can be overriden with more roles.
//     sourceRepos: [],  //Must be provided as overrides.
//   },
// };
// {
//   Get: function(p) [
//     defaultProjectTemplate('platform') {
//       spec+: {
//         destinations: [
//           {
//             namespace: '*',
//             server: '*',
//           },
//         ],
//         roles: [
//           {
//             description: 'Platform Administrator',
//             groups: [
//               'platform-admin',
//             ],
//             name: 'admin',
//             policies: [
//               'p, proj:platform:admin, applications, *, platform/*, allow',
//             ],
//           },
//         ],
//         sourceRepos: [
//           '*',
//         ],
//         syncWindows: if std.substr(p.uri, 7, 3) == 'prd' then [
//           {
//             kind: 'allow',
//             schedule: '0 18 * * 6',
//             duration: '16h',
//             manualSync: true,
//             applications: [
//               '*-nginx',
//               '*-velero',
//               '*-external-dns',
//               '*-argo-events',
//               '*-argo-rollouts',
//               '*-cert-manager',
//               '*-eck-operator',
//               '*-external-secrets-operator',
//               '*-filebeat',
//               '*-grafana-dashboards',
//               '*-grafana-operator',
//               '*-kube-eagle',
//               '*-misc',
//               '*-nginx',
//               '*-prometheus',
//               '*-prometheus-crds',
//               '*-prometheus-rules',
//               '*-sealed-secrets',
//               '*-velero',
//               '*-metallb',
//               '*-longhorn',
//               //'*-thanos', //Disable thanos schedule sync for every saturday
//               '*-fluent-bit',
//               '*-argocd'
//             ],

//             timeZone: p.timeZone,
//           },
//         ] else [],
//       },
//     },
//   ],
// }