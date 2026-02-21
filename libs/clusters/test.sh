#!/bin/sh
set -euo pipefail

CLUSTERS_FILE="remote/clusters.json"
KUBECONFIG_DIR="$HOME/.kube/clusters"

# Ensure output dir exists
mkdir -p "$(dirname "$CLUSTERS_FILE")"

# Start with empty array
echo "[]" > "$CLUSTERS_FILE"

# Iterate over all kubeconfig files
for KUBECONFIG_FILE in "$KUBECONFIG_DIR"/*; do
    [ -f "$KUBECONFIG_FILE" ] || continue
    echo "Processing kubeconfig: $KUBECONFIG_FILE"

    # Extract cluster names
    CLUSTER_NAMES=$(yq e '.clusters[].name' "$KUBECONFIG_FILE")

    for CLUSTER in $CLUSTER_NAMES; do
        echo "Extracting cluster: $CLUSTER"

        # Server
        SERVER=$(yq e ".clusters[] | select(.name == \"$CLUSTER\") | .cluster.server" "$KUBECONFIG_FILE")

        # CA
        CA_FILE=$(yq e ".clusters[] | select(.name == \"$CLUSTER\") | .cluster.certificate-authority" "$KUBECONFIG_FILE")
        CA_DATA=$(yq e ".clusters[] | select(.name == \"$CLUSTER\") | .cluster.certificate-authority-data" "$KUBECONFIG_FILE")
        if [ -n "$CA_FILE" ] && [ -f "$CA_FILE" ]; then
            # Alpine-compatible base64 (single line)
            CA_DATA=$(openssl base64 -A -in "$CA_FILE")
        fi

        # User
        USER_NAME=$(yq e ".contexts[] | select(.context.cluster == \"$CLUSTER\") | .context.user" "$KUBECONFIG_FILE")

        CERT_FILE=$(yq e ".users[] | select(.name == \"$USER_NAME\") | .user.client-certificate" "$KUBECONFIG_FILE")
        KEY_FILE=$(yq e ".users[] | select(.name == \"$USER_NAME\") | .user.client-key" "$KUBECONFIG_FILE")
        CERT_DATA=$(yq e ".users[] | select(.name == \"$USER_NAME\") | .user.client-certificate-data" "$KUBECONFIG_FILE")
        KEY_DATA=$(yq e ".users[] | select(.name == \"$USER_NAME\") | .user.client-key-data" "$KUBECONFIG_FILE")

        if [ -n "$CERT_FILE" ] && [ -f "$CERT_FILE" ]; then
            CERT_DATA=$(openssl base64 -A -in "$CERT_FILE")
        fi
        if [ -n "$KEY_FILE" ] && [ -f "$KEY_FILE" ]; then
            KEY_DATA=$(openssl base64 -A -in "$KEY_FILE")
        fi

        # Create cluster object
        NEW_CLUSTER=$(jq -n \
            --arg name "$CLUSTER" \
            --arg server "$SERVER" \
            --arg caData "$CA_DATA" \
            --arg certData "$CERT_DATA" \
            --arg keyData "$KEY_DATA" \
            '{
                name: $name,
                server: $server,
                tlsClientConfig: {
                    insecure: false,
                    caData: $caData,
                    certData: $certData,
                    keyData: $keyData
                }
            }'
        )

        # Append to clusters.json
        TMPFILE=$(mktemp)
        jq --argjson newCluster "$NEW_CLUSTER" '. + [$newCluster]' "$CLUSTERS_FILE" > "$TMPFILE" && mv "$TMPFILE" "$CLUSTERS_FILE"

        echo "Added cluster: $CLUSTER (server: $SERVER, user: $USER_NAME)"
    done
done

echo "All clusters extracted and stored in $CLUSTERS_FILE"
