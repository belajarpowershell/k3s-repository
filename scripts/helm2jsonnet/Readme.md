
# 🧠 High-Level Summary

This script:

> 📦 Downloads a specific version of the **Argo CD Helm chart**,
> 📂 Vendors it into your Git repo under `libs/`,
> 🔄 Converts its `values.yaml` into Jsonnet format,
> ➕ Creates a Jsonnet overlay for SSL passthrough.

It prepares the chart so you can manage it with **Jsonnet instead of raw YAML**.

---

## 🔎 Step-by-Step Summary

### 1️⃣ Sets Chart Configuration

It defines:

* Helm repo:
  Argo Project Helm repository
  `https://argoproj.github.io/argo-helm`

* Chart name: `argo-cd`

* Version: `6.7.6`

So it is targeting:

👉 The **Argo CD Helm chart v6.7.6**

---

### 2️⃣ Ensures Required Tools Exist

It checks for:

* `helm`
* `yq`
* `jsonnetfmt`
* `git`

If any are missing → script exits immediately.

---

### 3️⃣ Adds & Updates Helm Repo

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

Ensures the Argo Helm repository is available locally.

---

### 4️⃣ Pulls the Chart to a Temporary Directory

```bash
helm pull argo/argo-cd --version 6.7.6 --untar
```

This:

* Downloads the chart
* Extracts it
* Places it in a temporary directory

---

### 5️⃣ Vendors the Chart into Your Git Repo

It moves the extracted chart into:

```
libs/argo-cd-6.7.6/
```

So now your repo contains a **pinned copy** of the chart.

👉 This is Helm chart vendoring (GitOps best practice).

---

### 6️⃣ Converts `values.yaml` → `values.libsonnet`

This is the key transformation:

```bash
yq -o=json values.yaml | jsonnetfmt - > values.libsonnet
```

What happens:

1. `values.yaml` → JSON (via `yq`)
2. JSON → formatted Jsonnet
3. Saved as `values.libsonnet`

Now your Helm values can be:

* Imported in Jsonnet
* Merged
* Overridden cleanly

This fits perfectly into your ArgoCD + Jsonnet CMP setup.

---

### 7️⃣ Creates a Jsonnet Overlay

This is an example on the custom changes you want to introduce. 
In this example the `ssl-passthrough` does not apply to ArgoCD
It generates:

```jsonnet
overlay-ssl-passthrough.libsonnet
```

Which enables:

```jsonnet
{
  controller: {
    extraArgs: {
      "enable-ssl-passthrough": "true",
    },
  },
}
```

So later you can do:

```jsonnet
baseValues + overlaySsl
```

Clean composable configuration.

---

### 8️⃣ Cleans Up

Deletes the temporary directory.

---

## 🎯 Final Result

After running this script, you will have:

```
libs/
  argo-cd-6.7.6/
    Chart.yaml
    values.yaml
    values.libsonnet
    overlay-ssl-passthrough.libsonnet
    templates/
```

And your repo now:

* Contains a pinned Helm chart
* Is Jsonnet-ready
* Supports overlay-based configuration
* Is GitOps friendly

---

## 🔥 In One Sentence

This script **vendors the Argo CD Helm chart into your repo and converts it into a Jsonnet-friendly format so it can be managed via your ArgoCD + Jsonnet workflow.**

---

If you want, I can also explain why this pattern is superior to directly referencing the remote Helm repo in ArgoCD.
