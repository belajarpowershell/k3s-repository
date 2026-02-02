# kube.libsonnet

A Jsonnet library of Kubernetes resource constructors and helpers to produce valid Kubernetes API objects programmatically.

## Purpose

This library provides jsonnet-friendly wrappers around Kubernetes API objects, with optional helpers and defaults for common use cases. See `libs/kube.libsonnet`.

## Key Concepts

### Underscore Helpers

Fields ending with `_` (e.g., `env_`, `ports_`, `volumes_`) are convenient jsonnet-native maps/objects that the library automatically converts into Kubernetes arrays:

```jsonnet
kube.Container("foo") {
  env_: { FOO: "bar" },
}
```

Produces:

```json
{
  "env": [
    { "name": "FOO", "value": "bar" }
  ]
}
```

### Hidden Helpers / Defaults

Constructors expose helper fields (double-colon `::` style) and default behavior for common cases. For example, `Service.target_pod` automatically builds `selector` and `ports` fields from the pod definition.

### Assertions Toggle

Set `_assert:: false` when importing to skip runtime checks for speed:

```jsonnet
local kube = (import "libs/kube.libsonnet") { _assert:: false };
```

## Utility Functions

- `hyphenate(s)` — replace `_` with `-`
- `parseOctal(s)` — convert octal string to number
- `siToNum(n)` — convert SI unit suffixes (K, M, G, etc.) to numbers
- `mapToNamedList(o)` — convert `{foo: {a: b}}` to `[{name: foo, a: b}]`
- `objectValues(o)` / `objectItems(o)` — extract values or key-value pairs
- `toLower(s)` / `toUpper(s)` — case conversion

## Principal Constructors

- `Namespace(name)`
- `Service(name)` — with `target_pod` helper
- `Pod(name)` / `PodSpec`
- `Container(name)` — with `env_`, `ports_`, `volumeMounts_` helpers
- `ConfigMap(name)`
- `Secret(name)` — with base64 encoding via `data_`
- `PersistentVolume(name)`
- `PersistentVolumeClaim(name)` — with `storageClass` and `storage` helpers
- `StorageClass(name)`
- `PodDisruptionBudget(name)`
- `List()` — with `items_` helper
- Volume helpers: `EmptyDirVolume()`, `HostPathVolume()`, `GitRepoVolume()`, `SecretVolume()`, `ConfigMapVolume()`, `PersistentVolumeClaimVolume()`

## Usage Example

```jsonnet
local kube = import 'libs/kube.libsonnet';

local pod = kube.Pod('my-pod') {
  metadata+: { namespace: 'default' },
  spec+: {
    containers_: {
      app: {
        image: 'nginx:1.21',
        ports_: { http: { containerPort: 80 } },
      },
    },
  },
};

local svc = kube.Service('my-svc') {
  metadata+: { namespace: 'default' },
  target_pod:: pod,
};

kube.List() {
  items_:: {
    pod: pod,
    svc: svc,
  },
}
```

Render with: `jsonnet your-file.jsonnet`

## Notes & Gotchas

- **Underscore conversion:** Be aware that `_`-suffixed fields are automatically converted to arrays. If you don't want this, set the regular (non-underscore) field directly.
- **Field assertions:** Turn on `_assert` for clearer error messages when debugging.
- **Missing fields:** Some helpers assume required fields exist (e.g., `target_pod.metadata.labels`). Supply these fields or adjust assertions as needed.
- **Data types:** ConfigMap `data` values must be strings; Secret `data_` values are automatically base64-encoded.
