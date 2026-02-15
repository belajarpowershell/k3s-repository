# clustermanagement.libsonnet

Helpers to generate Argo CD Application and AppProject objects for cluster-level orchestration. Standardizes how cluster apps are created from a cluster configuration object.

## Purpose

This library abstracts common Argo CD patterns for multi-cluster management, providing constructors that take a cluster configuration and app metadata and produce properly configured Application/AppProject manifests.

See `libs/clustermanagement.libsonnet`.

## Dependencies

- `argocd.libsonnet` — Argo CD API helpers
- `globals.libsonnet` — global config (git repos, namespaces, etc.)
- `kube.libsonnet` — Kubernetes base constructors

## Main Constructors

### Cluster-Level Applications

- `ClusterApp(cluster)` — Argo CD Application for the cluster's umbrella app (namespace: `argocd`)
- `ClusterAppWithAutoSync(cluster)` — same as `ClusterApp` but with automated sync enabled
- `BaseClusterApp(cluster)` — application with internal repo URL for cluster config
- `ClusterAppProject(cluster)` — creates an Argo CD AppProject with scoped sourceRepos and destinations

### Application Constructors

- `App(cluster, name, namespace)` — regular app pointing to `getApplicationPath(cluster, name)`, project determined by `isPlatformApplications()`
- `AppWithAutoSync(cluster, name, namespace)` — same as `App` with auto-sync (prune/selfHeal)
- `JsonnetHelmApplication(cluster, name, namespace)` — `App` with `jsonnet-helm` CMP plugin
- `JsonnetHelmApplicationWithCrds(cluster, name, namespace)` — `App` with `jsonnet-helm-with-crds` plugin
- `JsonnetHelmApplicationWithCrdsAutosync(cluster, name, namespace)` — with auto-sync enabled
- `JsonnetHelmApplicationCustomProj(cluster, name, namespace, project)` — with custom project override

### Path Helpers

- `getApplicationPath(cluster, name)` — returns repo path based on cluster hierarchy (region/countryFactory/environment/cluster/name)
- `getApplicationPathCMS(cluster)` — variant for CMS apps (cms/region/countryFactory/environment/cluster)
- `isPlatformApplications(name, namespace)` — returns `true` if namespace is in platform list (determines project assignment)

## Expected Cluster Object

Most constructors assume the cluster object has these fields:

```jsonnet
{
  name: 'k3s-master',           // required: used in app names/paths
  nickname: 'k3s-master',       // required: destination name in Argo CD
  region: 'az1',                // optional: used by getApplicationPath
  countryFactory: 'factory',    // optional: used by getApplicationPath
  environment: 'dev',           // optional: used by getApplicationPath
  uri: 'https://api.example',   // optional: cluster API endpoint
  clustertype: 'k3s',           // optional: used by templates
  k3s_type: 'server',           // optional
}
```

## Usage Example

```jsonnet
local cm = import 'libs/clustermanagement.libsonnet';

local cluster = {
  name: 'k3s-master',
  nickname: 'k3s-master',
  region: 'az1',
  countryFactory: 'factory',
  environment: 'dev',
};

// Create a Jsonnet+Helm app with CRDs
cm.JsonnetHelmApplicationWithCrds(cluster, 'cert-manager', 'cert-manager') {
  spec+: {
    syncPolicy: {
      automated: { prune: true },
      syncOptions: ['CreateNamespace=true'],
    },
  },
}
```

## Common Pitfalls

1. **Missing cluster fields** — If `name`, `nickname`, or other expected fields are missing, you'll get "Field does not exist" errors. Ensure your cluster config is complete.
2. **Path mismatch** — `getApplicationPath*` must match your actual repo layout. If your structure differs, adjust the path logic.
3. **Platform namespaces** — `isPlatformApplications()` uses a hard-coded whitelist. Add new platform namespaces if needed.
4. **CMP plugin names** — The `PLUGIN` env value must match your Argo CD config management plugin configuration. Common values: `jsonnet-helm`, `jsonnet-helm-with-crds`.

## How It's Used

Other Jsonnet files (e.g., `clusters/default-apps.jsonnet`) import this library and call constructors with a cluster config to generate Argo CD Applications for each workload cluster and application.

Example:

```jsonnet
local defaults = import '../libs/clustermanagement.libsonnet';
local p = import './cluster.jsonnet';  // cluster config

{
  cert_manager: defaults.JsonnetHelmApplicationWithCrds(p, 'cert-manager', 'cert-manager') { /* ... */ },
  nginx: defaults.JsonnetHelmApplication(p, 'nginx', 'nginx') { /* ... */ },
}
```
