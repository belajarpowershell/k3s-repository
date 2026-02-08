#!/usr/bin/env bash
set -euo pipefail

############################################
# Config
############################################
REPO_NAME="argo"
REPO_URL="https://argoproj.github.io/argo-helm"
CHART_NAME="argo-cd"
CHART_VERSION="5.26.0"

REPO_ROOT="$(git rev-parse --show-toplevel)"
LIBS_DIR="${REPO_ROOT}/libs"
OUTDIR="${LIBS_DIR}/${CHART_NAME}-${CHART_VERSION}"
TMPDIR="$(mktemp -d)"

############################################
# Prereqs
############################################
for cmd in helm yq jsonnetfmt git; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "❌ Missing required tool: $cmd"
    exit 1
  }
done

############################################
# Helm repo setup
############################################
echo "▶ Ensuring Helm repo exists"
helm repo add "$REPO_NAME" "$REPO_URL" >/dev/null 2>&1 || true
helm repo update >/dev/null

############################################
# Pull chart into temp dir
############################################
echo "▶ Pulling ${CHART_NAME}-${CHART_VERSION}"
helm pull "${REPO_NAME}/${CHART_NAME}" \
  --version "${CHART_VERSION}" \
  --untar \
  --untardir "${TMPDIR}"

############################################
# Move chart into libs/
############################################
echo "▶ Installing chart into libs/"
rm -rf "${OUTDIR}"
mkdir -p "${LIBS_DIR}"
mv "${TMPDIR}/${CHART_NAME}" "${OUTDIR}"

############################################
# Convert values.yaml → values.libsonnet
############################################
cd "${OUTDIR}"

echo "▶ Converting values.yaml to values.libsonnet"
yq -o=json values.yaml | jsonnetfmt - > values.libsonnet

############################################
# Create overlay for ssl-passthrough
############################################
cat <<'EOF' > overlay-ssl-passthrough.libsonnet
{
  controller: {
    extraArgs: {
      "enable-ssl-passthrough": "true",
    },
  },
}
EOF

############################################
# Cleanup
############################################
rm -rf "${TMPDIR}"

############################################
# Done
############################################
echo "✅ Chart installed in ${OUTDIR}"
echo "📦 Ready for Jsonnet imports"
