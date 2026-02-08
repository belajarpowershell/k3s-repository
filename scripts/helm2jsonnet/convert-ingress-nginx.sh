# #!/usr/bin/env bash
# set -euo pipefail

# ############################################
# # Config
# ############################################
# REPO_NAME="ingress-nginx"
# REPO_URL="https://kubernetes.github.io/ingress-nginx"
# CHART_NAME="ingress-nginx"
# CHART_VERSION="4.10.0"

# REPO_ROOT="$(git rev-parse --show-toplevel)"
# LIBS_DIR="${REPO_ROOT}/libs"
# OUTDIR="${LIBS_DIR}/${CHART_NAME}-${CHART_VERSION}"
# TMPDIR="$(mktemp -d)"

# ############################################
# # Prereqs
# ############################################
# for cmd in helm yq jsonnetfmt git; do
#   command -v "$cmd" >/dev/null 2>&1 || {
#     echo "❌ Missing required tool: $cmd"
#     exit 1
#   }
# done

# ############################################
# # Helm repo setup
# ############################################
# echo "▶ Ensuring Helm repo exists"
# helm repo add "$REPO_NAME" "$REPO_URL" >/dev/null 2>&1 || true
# helm repo update >/dev/null

# ############################################
# # Pull chart into temp dir
# ############################################
# echo "▶ Pulling ${CHART_NAME}-${CHART_VERSION}"
# helm pull "${REPO_NAME}/${CHART_NAME}" \
#   --version "${CHART_VERSION}" \
#   --untar \
#   --untardir "${TMPDIR}"

# ############################################
# # Move chart into libs/
# ############################################
# echo "▶ Installing chart into libs/"
# rm -rf "${OUTDIR}"
# mkdir -p "${LIBS_DIR}"
# mv "${TMPDIR}/${CHART_NAME}" "${OUTDIR}"

# ############################################
# # Convert values.yaml → values.libsonnet
# ############################################
# cd "${OUTDIR}"

# echo "▶ Converting values.yaml to values.libsonnet"
# yq -o=json values.yaml | jsonnetfmt - > values.libsonnet

# ############################################
# # Create overlay for ssl-passthrough
# ############################################
# cat <<'EOF' > overlay-ssl-passthrough.libsonnet
# {
#   controller: {
#     extraArgs: {
#       "enable-ssl-passthrough": "true",
#     },
#   },
# }
# EOF

# ############################################
# # Cleanup
# ############################################
# rm -rf "${TMPDIR}"

# ############################################
# # Done
# ############################################
# echo "✅ Chart installed in ${OUTDIR}"
# echo "📦 Ready for Jsonnet imports"

################# following also converts Chart.yaml
## But Chart.yaml is used to generate the k8s manifest for ingress-nginx
# #!/usr/bin/env bash
# set -euo pipefail

# ############################################
# # Config
# ############################################
# REPO_NAME="ingress-nginx"
# REPO_URL="https://kubernetes.github.io/ingress-nginx"
# CHART_NAME="ingress-nginx"
# CHART_VERSION="4.10.0"

# REPO_ROOT="$(git rev-parse --show-toplevel)"
# LIBS_DIR="${REPO_ROOT}/libs"
# OUTDIR="${LIBS_DIR}/${CHART_NAME}-${CHART_VERSION}"
# TMPDIR="$(mktemp -d)"

# ############################################
# # Prereqs
# ############################################
# for cmd in helm yq jsonnetfmt git jq; do
#   command -v "$cmd" >/dev/null 2>&1 || {
#     echo "❌ Missing required tool: $cmd"
#     exit 1
#   }
# done

# ############################################
# # Helm repo setup
# ############################################
# helm repo add "$REPO_NAME" "$REPO_URL" >/dev/null 2>&1 || true
# helm repo update >/dev/null

# ############################################
# # Pull chart
# ############################################
# helm pull "${REPO_NAME}/${CHART_NAME}" \
#   --version "${CHART_VERSION}" \
#   --untar \
#   --untardir "${TMPDIR}"

# ############################################
# # Move to libs/
# ############################################
# rm -rf "${OUTDIR}"
# mkdir -p "${LIBS_DIR}"
# mv "${TMPDIR}/${CHART_NAME}" "${OUTDIR}"

# ############################################
# # Convert all YAMLs in the chart root to Jsonnet
# ############################################
# cd "${OUTDIR}"

# for yaml_file in ./*.yaml ./*.yml; do
#     [[ -f "$yaml_file" ]] || continue   # skip if no match
#     base_name=$(basename "${yaml_file%.*}")
#     lib_file="${base_name}.libsonnet"

#     echo "▶ Converting $yaml_file -> $lib_file"

#     # Wrap YAML as function taking overrides
#     echo "function(overrides) (" > "${lib_file}"
#     yq -o=json eval "${yaml_file}" | jq '.' >> "${lib_file}"
#     echo ") + overrides" >> "${lib_file}"

#     jsonnetfmt -i "${lib_file}"
# done

# ############################################
# # Create customization.libsonnet if missing
# ############################################
# CUSTOM_FILE="${OUTDIR}/customization.libsonnet"

# if [[ ! -f "${CUSTOM_FILE}" ]]; then
#   echo "▶ Creating customization.libsonnet"
#   cat <<'EOF' > "${CUSTOM_FILE}"
# // User-maintained overrides
# {
#   controller: {
#     extraArgs: {
#       "enable-ssl-passthrough": "true",
#     },
#   },
# }
# EOF
# fi

# ############################################
# # Cleanup
# ############################################
# rm -rf "${TMPDIR}"

# ############################################
# # Done
# ############################################
# echo "✅ Root YAML files converted to .libsonnet in ${OUTDIR}"
# echo "📄 customization.libsonnet created / preserved"
