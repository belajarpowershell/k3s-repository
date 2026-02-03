#!/bin/bash
#
# Automation script to generate jsonnet manifests and commit to git
# Usage: ./scripts/generate-and-commit-manifests.sh [cluster-name] [git-branch]
#

set -e

# Configuration
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLUSTERS_DIR="$REPO_ROOT/clusters"
LIBS_DIR="$REPO_ROOT/libs"
MANIFESTS_OUTPUT_DIR="$REPO_ROOT/generated-manifests"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Arguments
CLUSTER_NAME="${1:-k3s-master}"
GIT_BRANCH="${2:-main}"
COMMIT_MESSAGE="${3:-Auto-generate manifests for $CLUSTER_NAME ($TIMESTAMP)}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if cluster exists
if [ ! -d "$CLUSTERS_DIR/$CLUSTER_NAME" ]; then
    log_error "Cluster directory not found: $CLUSTERS_DIR/$CLUSTER_NAME"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$MANIFESTS_OUTPUT_DIR"

log_info "Generating manifests for cluster: $CLUSTER_NAME"

# Generate the manifest
MANIFEST_FILE="$MANIFESTS_OUTPUT_DIR/${CLUSTER_NAME}-apps-${TIMESTAMP}.yaml"
if jsonnet -J "$LIBS_DIR" "$CLUSTERS_DIR/$CLUSTER_NAME/apps.jsonnet" > "$MANIFEST_FILE"; then
    log_info "Manifest generated successfully: $MANIFEST_FILE"
else
    log_error "Failed to generate manifest"
    exit 1
fi

# Also create a 'latest' symlink for easy reference
LATEST_LINK="$MANIFESTS_OUTPUT_DIR/${CLUSTER_NAME}-apps-latest.yaml"
ln -sf "$(basename "$MANIFEST_FILE")" "$LATEST_LINK"
log_info "Created latest symlink: $LATEST_LINK"

# Check git status
cd "$REPO_ROOT"
if [ -n "$(git status --porcelain)" ]; then
    log_info "Changes detected in git repo"
fi

# Stage the manifest
git add "$MANIFEST_FILE" "$LATEST_LINK" 2>/dev/null || true

# Check if there are changes to commit
if git diff --cached --quiet; then
    log_warn "No changes to commit"
    exit 0
fi

# Configure git if needed
if [ -z "$(git config user.email)" ]; then
    log_info "Configuring git user..."
    git config user.email "automation@k3s.local"
    git config user.name "Manifest Automation"
fi

# Commit the changes
if git commit -m "$COMMIT_MESSAGE"; then
    log_info "Committed changes: $COMMIT_MESSAGE"
else
    log_error "Failed to commit changes"
    exit 1
fi

# Push to remote (optional - comment out if not needed)
if git push origin "$GIT_BRANCH" 2>/dev/null; then
    log_info "Pushed changes to origin/$GIT_BRANCH"
else
    log_warn "Could not push to remote (might not be configured)"
fi

log_info "✓ Automation complete!"
echo ""
echo "Next steps:"
echo "1. Apply the manifest to your cluster:"
echo "   kubectl apply -f $LATEST_LINK -n argocd"
echo ""
echo "2. Or let ArgoCD sync automatically (if configured)"
