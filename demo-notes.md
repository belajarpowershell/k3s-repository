Absolutely! I've taken your draft and refined it into a structured, clean, and presentation-friendly **Markdown** format. I added headers, code blocks, formatting, and minor improvements for clarity, flow, and readability. I also included some extra context to make it easier for an audience to follow.

Here’s the improved version:

---

# Deploying Applications using Jsonnet, Helm Charts, and ArgoCD

## 🎯 Goal of This Session

* Share hands-on experience with deploying applications using Jsonnet and Helm via ArgoCD.
* Focus on practical demonstrations, no expectations or prerequisites.

---

## 📝 Explanation

### What is Jsonnet?

* Jsonnet is a **data-templating language** that allows you to generate JSON/YAML manifests programmatically.
* Helps **reduce repetition**, manage **templated deployments**, and maintain **consistent configurations** across environments.

### Why Jsonnet?

* Simplifies managing **multiple clusters** and applications.
* Works seamlessly with **Helm charts** to generate Kubernetes manifests.
* Makes your **GitOps workflow cleaner**, especially with ArgoCD.

---

## 📂 Folder Structure

```
k3s-repository/
├── argocd/        # ArgoCD installation per cluster
├── clusters/      # Cluster-specific applications
├── libs/          # Vendored Helm charts (Jsonnet-ready)
├── platform/      # Global App-of-Apps
├── scripts/       # Automation helpers
├── readme/        # Documentation
└── scratch/       # Experiments
```

---

## ⚙️ How Manifests Are Generated

* Jsonnet converts **Helm charts** and configuration into **Kubernetes manifests**.
* Example flow:

  1. Import Helm chart as Jsonnet.
  2. Generate manifests using Jsonnet.
  3. Apply manifests with `kubectl` or via ArgoCD.

---

## 🔹 Demo Setup

### Clusters

* **1 Master Cluster (k3s-master)** – Hosts ArgoCD.
* **3 Application Clusters**

  * k3s-01
  * k3s-02
  * k3s-03

### Step 1: Install Ingress-NGINX and ArgoCD on Master

```bash
# Create namespace
kubectl create ns ingress-nginx
kubectl create ns argocd
```

#### Ingress-NGINX

```bash
cd ~/k3s-repository/clusters/k3s-master/ingress-nginx/
mkdir -p ./templates

# Generate Jsonnet manifests from Helm chart
jsonnet -m . helm-chart.libsonnet
helm dependency build
[ -f './templates/_templates.jsonnet' ] && jsonnet ./templates _templates.jsonnet > ./templates/templates.yaml

# Apply manifests via Helm template
helm template k3s-master-ingress-nginx . --namespace ingress-nginx --include-crds \
  | kubectl apply -f - --namespace ingress-nginx --dry-run=client
```

#### ArgoCD

```bash
cd ~/k3s-repository/argocd/k3s-master/
mkdir -p ./templates

jsonnet -m . helm-chart.libsonnet
helm dependency build
[ -f './templates/_templates.jsonnet' ] && jsonnet ./templates _templates.jsonnet > ./templates/templates.yaml

helm template k3s-master-argocd . --namespace argocd --include-crds \
  | kubectl apply -f - --namespace argocd
```

---

### Step 2: Open ArgoCD

* Open **ArgoCD UI** in browser.
* Initial UI may appear blank.

---

### Step 3: Add Remote Clusters

```bash
# Login to ArgoCD
argocd login argocd-master.k8s.lab --insecure

# Add clusters
kubectl config use-context k3s-01
argocd cluster add k3s-01 --insecure

kubectl config use-context k3s-02
argocd cluster add k3s-02 --insecure

kubectl config use-context k3s-03
argocd cluster add k3s-03 --insecure

kubectl config use-context k3s-master
argocd cluster add k3s-master --insecure
```

---

### Step 4: Apply App-of-Apps

* Switch context back to master:

```bash
kubectl config use-context k3s-master
cd ~/k3s-repository/
jsonnet main.jsonnet | kubectl apply -f -
```

* Key observations:

  * ArgoCD shows **differences** but does not recreate existing deployments.
  * Shows **logs and events** for applied resources.
  * Enables **sync and upgrade** operations.

---

### Step 5: Update Helm Charts

```bash
cd ~/k3s-repository/scripts/helm2jsonnet
sh convert-argocd-9.4.3.sh
```

* Script generates:

```
├── chart.libsonnet          # Static across deployments
├── parameters.json          # Static configuration
├── customizations.libsonnet # Blank for customization
├── extras.libsonnet         # Blank for extra resources
├── values.libsonnet         # Converted from values.yaml
├── cluster-onboarding.jsonnet # Adds remote clusters
└── projects.libsonnet       # ArgoCD projects config
```

---

### Step 6: Test and Apply Updated Helm Reference

```bash
cd ~/k3s-repository/argocd/k3s-master/
mkdir -p ./templates

jsonnet -m . helm-chart.libsonnet
helm dependency build
[ -f './templates/_templates.jsonnet' ] && jsonnet ./templates _templates.jsonnet > ./templates/templates.yaml

helm template k3s-master-argocd . --namespace argocd --include-crds \
  | kubectl apply -f - --namespace argocd --dry-run=client
```

---

## ✅ Summary

* Jsonnet enables **repeatable, consistent, and templated deployments**.
* ArgoCD provides a **GitOps workflow** to manage multiple clusters.
* Combining Jsonnet + Helm + ArgoCD gives you **scalable and maintainable infrastructure deployments**.
* App-of-Apps pattern allows deploying **cluster-specific resources from a single source repository**.

---

If you want, I can also make a **version with diagrams and visuals** to illustrate:

1. Folder structure
2. Master → Application cluster flow
3. Jsonnet + Helm + ArgoCD pipeline

It’ll make your session much more visual and audience-friendly.

Do you want me to do that?
