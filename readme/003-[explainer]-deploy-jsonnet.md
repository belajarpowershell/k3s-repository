# Deploying generated manifest from jsonnet

Jsonnet when generating a HELM manifest, generates Argo CD Helm inputs.

Current output.

```json

{
  "Chart.yaml": {
    "apiVersion": "v2",
    "name": "argo-cd",
    "version": "4.10.0"
  },
  "values.yaml": {
    "server": { ... },
    "repoServer": { ... }
  }
}


```

expected

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: argocd-server
...

```

## Transformation required

run from `repo/argocd/k3s-master/helm`

### 1. Ensure the templates directory exists

```bash
mkdir -p ./templates

```

### 2. Run jsonnet to generate files, using `-m .` to output multiple files into the current directory

This generates 'chart.yaml' and 'values.yaml'

```bash
jsonnet -m . helm-chart.libsonnet
```

### 3. Build Helm chart dependencies (if any are defined in Chart.yaml)

This updates helm charts and downloads the helm charts locally.

```bash
helm dependency build
```

## 4. If the file './templates/_templates.jsonnet' exists, render it and output the result to templates.yaml

```bash
if [ -f './templates/_templates.jsonnet' ]; then
  jsonnet ./templates/_templates.jsonnet > ./templates/templates.yaml
fi
```
