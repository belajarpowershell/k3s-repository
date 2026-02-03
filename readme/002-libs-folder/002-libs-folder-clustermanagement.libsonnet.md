`clustermanagement.libsonnet`

Summary of clustermanagement.libsonnet

Purpose: helpers to generate Argo CD Application and AppProject objects for cluster-level orchestration. It standardizes how cluster apps are created from a cluster configuration object.

Key imports: argocd.libsonnet, globals.libsonnet, kube.libsonnet.

Main helpers / constructors:

getApplicationPath(cluster, name): returns the repo path for an app based on cluster fields (region, countryFactory, environment, name). Used by App source.path.
getApplicationPathCMS(cluster): (you added) variant that prefixes cms/ for CMS-specific repos.
isPlatformApplications(name, namespace): determines whether an app should be in the platform project based on a namespace whitelist.
ClusterApp(cluster): ArgoCD Application representing the cluster's umbrella application (namespace argocd).
ClusterAppWithAutoSync(cluster): same as ClusterApp but enables automated sync.
BaseClusterApp(cluster): application with a repo URL for cluster-level configuration (internal repo).
ClusterAppProject(cluster): creates an ArgoCD AppProject for cluster-scoped apps (populates sourceRepos and destinations).
App(cluster, name, namespace): produces a regular app pointing at getApplicationPath(cluster, name) and setting project to platform or default.
AppWithAutoSync(...): same as App but with automated sync (prune/selfHeal).
JsonnetHelmApplication* variants: wrapper around App to set a CMP plugin (jsonnet-helm / jsonnet-helm-with-crds) and optional autosync or custom project.
Expected cluster object fields (commonly referenced):

name (cluster name)
nickname (short local cluster identifier, used for destination.name)
region, countryFactory, environment (for path resolution)
uri, clusterName, clustertype, k3s_type (used elsewhere)
Common pitfalls / debugging tips:

Many functions assume cluster contains specific fields (name, nickname, region, etc). Missing fields will cause "Field does not exist" errors (you fixed several by adding name/nickname to cluster configs).
getApplicationPath* must match your repo layout; if your repo uses different folder structure, adjust accordingly.
isPlatformApplications uses a hard-coded namespace list; if you add platform namespaces, update it.
Plugin env values (PLUGIN names) must match your Argo CD config for config management plugins.
How it's used: other Jsonnet files (e.g., default-apps.jsonnet) call these constructors passing a cluster config p to generate Argo CD Applications for each app.


```
// Expected `cluster` object (example). Many helpers below assume
// these fields exist; missing fields will cause `Field does not exist` errors.
// {
//   name: 'k3s-master',           // required: cluster name used in app names/paths
//   nickname: 'k3s-master',       // required: destination name in argocd
//   region: 'az1',                // optional: used by getApplicationPath
//   countryFactory: 'factory',    // optional: used by getApplicationPath
//   environment: 'dev',           // optional: used by getApplicationPath
//   uri: 'https://api.example',   // optional: cluster API endpoint
//   clustertype: 'k3s',           // optional: used by templates
//   k3s_type: 'server',           // optional
// }
//
// Example usage:
// local cm = import 'libs/clustermanagement.libsonnet';
// cm.App({ name: 'k3s-master', nickname: 'k3s-master', region: 'az1' }, 'nginx', 'nginx')

```