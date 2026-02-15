# Convert Helm to Jsonnet

To use jsonnet helm, the first step is to convert helm charts to  jsonnet-helm format.

This involves downloading the helm chart and performing some conversions.

## Part 1 Download the helm chart

Helm chart

```bash
https://argoproj.github.io/argo-helm

```

Add repo to helm

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

Download

```bash
helm pull  argo/argo-cd --version 4.10.0
helm pull "$chart" --version "$version" --untar --untardir "$folder"
helm pull "argo/argo-cd" --version "4.10.0" --untar --untardir "argo-cd-4.10.0"

```

## Part 2  Extract the helm chart

```bash
mkdir /temp
tar -xzvf argo-cd-4.10.0.tgz -C /argo-cd-4.10.0
mv /temp/nginx/* /nginx-web/
rm -r /temp

```

## Part 3 Convert helm to jsonnet the process

Tools required

- yq install from `https://mikefarah.gitbook.io/yq/v/v3.x`
- jsonnet install from `https://github.com/google/jsonnet`

Using bash

Convert and format `values.yaml' to jsonnet format

```bash
yq -o json values.yaml | jsonnetfmt > values.libsonnet
```

## Part 4 the files!

### `cluster/k3s-master/ingress-nginx/helm/helm-chart.libsonnet`

This file name will be standard across applications

What this does

- references via the `chart` variable the chart from the libs folder. In this example `libs/ingress-nginx-4.10.0/Chart.libsonnet`
- imports cluster level parameters via `p` variable from the `params.libsonnet' file. Cluster specific parameters are stored here for common use.
- 

### `libs/ingress-nginx-4.10.0/Chart.libsonnet` case sensitive

The file that generates a Helm Structure programmatically.

Chart.yaml
> metadata (chart name, version, dependencies)

values.yaml
>  (default values merged with app-specific customizations)

customizations
> `values.yaml` is created from default values.yaml and specific custom values.

Observe that `Chart.libsonnet` is a template usable across applications.

```yaml
## variables extracted from various files 
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


```



chart.libsonnet
-get from templates folder no changes required

Chart.yaml
-this file is extracted from helm tar file. Contains all information to deploy the helm

values.libsonnet
-created by the commands
(yq -o json values.yaml | jsonnetfmt > values.libsonnet)

values.yaml
-this file is extracted from helm tar file. Contains all default values used in deployment

parameters.json
-create this file from template and fill in the location of the helm repository
The appname (this name will be part of the folder name)
The version (this version will complete the folder name)
