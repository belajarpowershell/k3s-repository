# Installing ArgoCD using Jsonnet

You would have at this stage finalised the initial setup configuration for ArgoCD.
Now you can begin the steps to templatize the deployment

## Download ArgoCD helm chart locally

The installation method will involve manual deployment of ArgoCD using the helm-jsonnet method via commandline.

### Step 1 Download the helm chart locally to the libs folder.

This script will perform the steps.

[convert-argocd](../scripts/helm2jsonnet/convert-argocd.sh)
The Readme will explain [](../scripts/helm2jsonnet/Readme.md)

This script downloads the Argo CD Helm chart into your repo and converts it into a Jsonnet-friendly format so it can be managed via your ArgoCD + Jsonnet workflow.



### Step 2

There are some new files that are required. To ensure a better understanding lets review the `libs` folder for the `argo-cd-6.7.6`

```txt

libs
├── 001-example
│   ├── chart.libsonnet
│   ├── customizations.libsonnet
│   ├── parameters.json
│   └── values.libsonnet
├── argo-cd-6.7.6
│   ├── Chart.yaml
│   ├── README.md
│   ├── charts
│   ├── templates
│   ├── values.yaml
/\ These files are from the downloaded Helm chart ( this is done by the script)
\/ The following files are created (*.json,*.jsonnet, *.libsonnet)
│   ├── chart.libsonnet ( as this is static across deployments this is created by script)
|   ├── parameters.json ( as this is static across deployments this is created by script)
│   ├── customizations.libsonnet ( blank file created by script)
│   ├── extras.libsonnet (blank file created by script)
│   ├── values.libsonnet ( this is created by the script converted from values.yaml)
│   ├── cluster-onboarding.jsonnet ( argocd specific configuration to add remote clusters )
│   └── projects.libsonnet (ArgoCD specific configuration to create ArgoCD projects)

```

#### `chart.libsonnet`

The content is the same for all the scenarios.
Observe there are 3 other files imported.

```yaml
#local globals = import '../globals.libsonnet';
local p = import 'parameters.json';
local c = import 'customizations.libsonnet';
local defaultValues = import 'values.libsonnet';
local extras = import 'extras.libsonnet';

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

#### `parameters.json`

This contains the applications Helm Chart details.
This is a static file.

```json
{
"repository": "https://argoproj.github.io/argo-helm",
"name": "argo-cd",
"version": "6.7.6"
}


```

#### `customizations.libsonnet`

This file contains the customization that is required for your application deployment. 
The configuration here over writes the default `values.yaml` that is created by the Helm Chart.
While `values.libsonnet` can be updated directly, we don't want upgrades overwriting the `values.libsonnet`. As this makes automation more challenging.
Custom changes will be implemented in this file.

Here is an example for ArgoCD, if you observe the parameters from the manual installation are specified here.

`customizations.libsonnet`

```yaml


# extras contain the configmap to be deployed in argocd.
local extras = import 'extras.libsonnet';

# add remote cluster kubeconfig in secrets
# Cluster onboarding is done manualy via ArgoCD CLI, due to complexities for a PoC.
# local clusterOnboarding = import 'cluster-onboarding.jsonnet';

# Create projects in ArgoCD
local projects = import './projects.libsonnet';

{
  Customizations(p):: {
    fullnameOverride: 'argocd',

    dex+: {
      enabled: false,
    },

    applicationSet+: {
      enabled: true,
    },

    server+: {
      extraArgs+: ['--insecure'],
      ingress+: {
        enabled: true,
        ingressClassName: 'nginx',
        hostname: 'argocd-master.k8s.lab', #p.hostname,
        domain: p.domain,
        hosts: 'argocd-master.k8s.lab',
        https: false,
        annotations+: {
          'nginx.ingress.kubernetes.io/backend-protocol': 'HTTP',

        },
      },
      insecure+: true,
    },

    configs+: {
      secret: {
        argocdServerAdminPassword: '$2b$12$3peDOQrx3EVLpfCJ.lRQQOSVNBiyjbJ0ofT79qrsdJvU9eTBG.mFm',
        argocdServerAdminPasswordMtime: '$(date +%FT%T%Z)',
      },
      cm+: {
        create: true,
        'exec.enabled': 'true',
      },
      repositories: p.repositories,
    },
...
    extraObjects+: [
    ]
    + projects,
  },
}

```

#### `values.libsonnet`

`values.libsonnet` is converted from the helm chart default `values.yaml`.
As a practice this file is not changed for custom configuration. This file will be overwritten by HelmChart upgrades and makes automation more challenging.
Custom changes will be done in `customizations.libsonnet`. As this is created outside of the Helm chart files.

#### `extras.libsonnet`

To modularize the addtional configurations, `extras.libsonnet` is used. In this example the plugins are configured.




----------------------------
Step 2
add customizations to the installation.
Lookup the customizations added `libs/argo-cd-5.26.0/customizations.libsonnet`

- Installation defaults

added subsequently

- Containers to perform conversion of helm.libsonnet to k8s manifest
- Plugins that use the containers with the coversion tools.
- k3s secrets containing the remote k3s KUBECONFIG as part of ARGOCD namespace.

Add using jsonnet helm

`$ARGOCD_APP_NAME=k3s-master-argocd # This is to ensure when adding this app to ArgoCD the existing resources are added`

```bash
mkdir -p ./templates && jsonnet -m . helm-chart.libsonnet && helm dependency build && [ -f './templates/_templates.jsonnet' ] && jsonnet ./templates _templates.jsonnet > ./templates/templates.yaml 

#helm template argocd . --namespace argocd  --include-crds    | kubectl apply -f -  --namespace argocd --dry-run=client

#helm template argocd . --namespace argocd  --include-crds    | kubectl delete -f -  --namespace argocd --dry-run=client

helm template k3s-master-argocd . --namespace argocd  --include-crds    | kubectl apply -f -  --namespace argocd --dry-run=client
```


## Install ARGOCD CLI 

```
apk add --no-cache curl ca-certificates

curl -sSL -o /usr/local/bin/argocd   https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64

chmod +x /usr/local/bin/argocd
argocd version


```

## Add cluster to ArgoCD via CLI

Change contexts for each k8s cluster before using ARGOCD cli to login
Adding remote cluster to Argocd via GitOps adds complexity for a PoC.
Adding remote clusters via ArgoCD CLI is quicker.

This is a one time effort
argocdServerAdmin=admin
argocdServerAdminPassword=YourSecurePassword

###

```bash
argocd login argocd-master.k8s.lab --insecure

```



```bash
kubectl config use-context k3s-master
argocd cluster add k3s-master  --insecure

kubectl config use-context k3s-01
argocd cluster add k3s-01  --insecure

kubectl config use-context k3s-02
argocd cluster add k3s-02  --insecure

kubectl config use-context k3s-03
argocd cluster add k3s-03  --insecure

```


## Install ingress-nginx

