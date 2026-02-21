#!/bin/bash
set -euo pipefail

CLUSTERS_FILE="remote/clusters.json"
KUBECONFIG_DIR="$HOME/.kube/clusters"

mkdir -p "$(dirname "$CLUSTERS_FILE")"
echo "[]" > "$CLUSTERS_FILE"

for KUBECONFIG_FILE in "$KUBECONFIG_DIR"/*; do
    [ -f "$KUBECONFIG_FILE" ] || continue
    echo "Processing kubeconfig: $KUBECONFIG_FILE"

    CLUSTER_NAMES=$(yq e '.clusters[].name' "$KUBECONFIG_FILE")
    for CLUSTER in $CLUSTER_NAMES; do
        echo "Extracting cluster: $CLUSTER"

        SERVER=$(yq e ".clusters[] | select(.name == \"$CLUSTER\") | .cluster.server" "$KUBECONFIG_FILE")

        CA_FILE=$(yq e ".clusters[] | select(.name == \"$CLUSTER\") | .cluster.certificate-authority" "$KUBECONFIG_FILE")
        CA_DATA=$(yq e ".clusters[] | select(.name == \"$CLUSTER\") | .cluster.certificate-authority-data" "$KUBECONFIG_FILE")
        [ -n "$CA_FILE" ] && [ -f "$CA_FILE" ] && CA_DATA=$(base64 "$CA_FILE" | tr -d '\n')

        USER_NAME=$(yq e ".contexts[] | select(.context.cluster == \"$CLUSTER\") | .context.user" "$KUBECONFIG_FILE")

        CERT_FILE=$(yq e ".users[] | select(.name == \"$USER_NAME\") | .user.client-certificate" "$KUBECONFIG_FILE")
        KEY_FILE=$(yq e ".users[] | select(.name == \"$USER_NAME\") | .user.client-key" "$KUBECONFIG_FILE")
        CERT_DATA=$(yq e ".users[] | select(.name == \"$USER_NAME\") | .user.client-certificate-data" "$KUBECONFIG_FILE")
        KEY_DATA=$(yq e ".users[] | select(.name == \"$USER_NAME\") | .user.client-key-data" "$KUBECONFIG_FILE")
        [ -n "$CERT_FILE" ] && [ -f "$CERT_FILE" ] && CERT_DATA=$(base64 "$CERT_FILE" | tr -d '\n')
        [ -n "$KEY_FILE" ] && [ -f "$KEY_FILE" ] && KEY_DATA=$(base64 "$KEY_FILE" | tr -d '\n')

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
            }')

        tmpfile=$(mktemp)
        jq --argjson newCluster "$NEW_CLUSTER" '. + [$newCluster]' "$CLUSTERS_FILE" > "$tmpfile" && mv "$tmpfile" "$CLUSTERS_FILE"

        echo "Added cluster: $CLUSTER (server: $SERVER, user: $USER_NAME)"
    done
done

echo "All clusters extracted and stored in $CLUSTERS_FILE"
