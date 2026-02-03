# Manifest Generation Automation

This directory contains scripts and workflows to automate the generation and deployment of Jsonnet manifests for ArgoCD.

## Quick Start

### 1. Make Script Executable
```bash
chmod +x scripts/generate-and-commit-manifests.sh scripts/pre-commit
```

### 2. Generate and Commit (Single Cluster)
```bash
# Option A: Using the script directly
./scripts/generate-and-commit-manifests.sh k3s-master

# Option B: Using make
make commit-manifests CLUSTER=k3s-master

# Option C: With custom commit message
./scripts/generate-and-commit-manifests.sh k3s-master main "My custom commit message"
```

### 3. Generate All Clusters
```bash
make generate-all
```

### 4. Apply to Kubernetes
```bash
# Apply specific cluster's manifests
make apply-manifests CLUSTER=k3s-master

# Or manually
kubectl apply -f generated-manifests/k3s-master-apps.yaml -n argocd
```

## Automation Options

### Option A: Pre-Commit Hook (Local)
Automatically generate manifests before each commit:

```bash
make setup-hooks
```

This will trigger manifest generation whenever you commit changes to:
- `clusters/*/`
- `libs/`

### Option B: GitHub Actions (CI/CD)
Automatically generate manifests on push:

1. Workflow file: `.github/workflows/generate-manifests.yml`
2. Triggers on:
   - Push to `main` branch
   - Changes to `clusters/`, `libs/`, or workflow file
   - Manual workflow dispatch

View results in GitHub Actions tab.

### Option C: Scheduled Cron Job
Generate manifests daily:

```bash
# Add to crontab (generate daily at 2 AM)
0 2 * * * cd /root/k3s-repository && bash scripts/generate-and-commit-manifests.sh k3s-master main

# Or for all clusters
0 2 * * * cd /root/k3s-repository && make generate-all && git add generated-manifests/ && git commit -m "Auto-generate manifests $(date +'%Y-%m-%d')" && git push origin main
```

### Option D: Manual with Make
```bash
# List all available commands
make help

# Generate specific cluster
make generate-manifests CLUSTER=k3s-master

# Generate all clusters
make generate-all

# Generate and commit
make commit-manifests CLUSTER=k3s-master

# Apply to cluster
make apply-manifests CLUSTER=k3s-master
```

## Workflow Output

All generated manifests are placed in `generated-manifests/`:

```
generated-manifests/
├── k3s-master-apps-20240203_150230.yaml  (timestamped)
├── k3s-master-apps-latest.yaml           (symlink to latest)
├── k3s1-apps-20240203_150230.yaml
├── k3s1-apps-latest.yaml
└── ...
```

## Integration with ArgoCD

### Method 1: Manual Apply
```bash
kubectl apply -f generated-manifests/k3s-master-apps-latest.yaml -n argocd
```

### Method 2: Commit to Git + ArgoCD Sync
1. Run: `make commit-manifests CLUSTER=k3s-master`
2. ArgoCD automatically detects git changes
3. Syncs based on your sync policy

### Method 3: Use App-of-Apps Pattern
ArgoCD watches the git repo and automatically applies generated manifests.

## Configuration

### Script Variables
Edit `scripts/generate-and-commit-manifests.sh`:
- `CLUSTER_NAME`: Default cluster (default: k3s-master)
- `GIT_BRANCH`: Target branch (default: main)
- `COMMIT_MESSAGE`: Custom commit message

### Git Configuration
```bash
# Set git user for commits (optional)
git config user.email "automation@k3s.local"
git config user.name "Manifest Automation"
```

## Troubleshooting

### Jsonnet not found
```bash
# Install jsonnet
apt-get install jsonnet
# or
brew install jsonnet
```

### Git permissions
```bash
# Ensure git credentials are configured
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"
```

### Pre-commit hook not triggering
```bash
# Verify hook is executable
ls -la .git/hooks/pre-commit

# Reinstall if needed
make setup-hooks
```

### Push fails (remote not configured)
```bash
# Set git remote
git remote add origin <your-repo-url>
git branch --set-upstream-to=origin/main main
```

## Examples

### Generate manifests for all clusters and push
```bash
make generate-all && \
git add generated-manifests/ && \
git commit -m "Auto-generate all manifests" && \
git push
```

### Generate and apply in one command
```bash
make commit-manifests CLUSTER=k3s-master && \
sleep 5 && \
make apply-manifests CLUSTER=k3s-master
```

### Monitor generated manifests
```bash
# Watch for changes
watch -n 5 'ls -lh generated-manifests/'

# View diff from previous version
diff <(git show HEAD:generated-manifests/k3s-master-apps-latest.yaml) generated-manifests/k3s-master-apps-latest.yaml
```
