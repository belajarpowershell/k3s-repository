#!/usr/bin/env bash
set -euo pipefail

############################################
# Config
############################################
REPO_NAME="jetstack"
REPO_URL="https://charts.jetstack.io"
CHART_NAME="cert-manager"
CHART_VERSION="v1.14.4"

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

if ! helm repo list | grep -q "^${REPO_NAME}\b"; then
  echo "▶ Adding Helm repo ${REPO_NAME}"
  helm repo add "$REPO_NAME" "$REPO_URL"
fi

echo "▶ Updating Helm repos"
helm repo update >/dev/null

############################################
# Validate version exists
############################################
if ! helm search repo "${REPO_NAME}/${CHART_NAME}" --versions \
    | grep -q "${CHART_VERSION}"; then
  echo "❌ Version ${CHART_VERSION} not found in ${REPO_NAME}/${CHART_NAME}"
  exit 1
fi

############################################
# Pull chart
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

cd "${OUTDIR}"

############################################
# Convert values.yaml → values.libsonnet
############################################
echo "▶ Converting values.yaml to values.libsonnet"
yq -o=json values.yaml | jsonnetfmt - > values.libsonnet

############################################
# Create parameters.json
############################################
echo "▶ Creating parameters.json"

cat <<EOF > parameters.json
{
  "repository": "${REPO_URL}",
  "name": "${CHART_NAME}",
  "version": "${CHART_VERSION}"
}
EOF

############################################
# Create customizations.libsonnet
############################################
echo "▶ Creating customizations.libsonnet"

cat <<'EOF' > customizations.libsonnet
{
  Customizations(p):: {
    // Override chart values here
  },
}
EOF

############################################
# Create extras.libsonnet
############################################
echo "▶ Creating extras.libsonnet"

cat <<'EOF' > extras.libsonnet
{
  // Add extra Kubernetes resources here
}
EOF

############################################
# Create chart.libsonnet
############################################
echo "▶ Creating chart.libsonnet"

cat <<'EOF' > chart.libsonnet
#local globals = import '../globals.libsonnet';

local p = import 'parameters.json';
local c = import 'customizations.libsonnet';
local defaultValues = import 'values.libsonnet';

local name = p.name;
local chartRepository = p.repository;
local chartVersion = p.version;
local extras = import 'extras.libsonnet';

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
EOF

############################################
# Cleanup
############################################
rm -rf "${TMPDIR}"

############################################
# Done
############################################
echo "✅ Chart installed in ${OUTDIR}"
echo "📦 parameters.json, customizations.libsonnet, extras.libsonnet, chart.libsonnet created"
echo "🚀 Ready for Jsonnet imports"
