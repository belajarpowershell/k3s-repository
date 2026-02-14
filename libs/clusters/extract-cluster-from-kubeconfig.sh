#!/bin/sh

CLUSTERS_FILE="remote/clusters.json"
KUBECONFIG_FILES=$(echo "$KUBECONFIG" | tr ':' ' ') # Split colon-separated paths

# Ensure the libs directory exists
mkdir -p "$(dirname "$CLUSTERS_FILE")"

# Check if clusters.json exists; if not, create an empty array
if [ ! -f "$CLUSTERS_FILE" ]; then
    echo "[]" > "$CLUSTERS_FILE"
fi

# Process each kubeconfig file
for KUBECONFIG_FILE in $KUBECONFIG_FILES; do
    if [ ! -f "$KUBECONFIG_FILE" ]; then
        echo "Warning: Kubeconfig file not found: $KUBECONFIG_FILE"
        continue
    fi

    echo "Processing kubeconfig: $KUBECONFIG_FILE"

    # Get cluster names from the kubeconfig
    CLUSTER_NAMES=$(yq e '.clusters[].name' "$KUBECONFIG_FILE")

    for CLUSTER in $CLUSTER_NAMES; do
        echo "Extracting cluster: $CLUSTER"

        # Extract server URL
        SERVER=$(yq e ".clusters[] | select(.name == \"$CLUSTER\") | .cluster.server" "$KUBECONFIG_FILE")

        # Extract TLS certificate data
        CA_FILE=$(yq e ".clusters[] | select(.name == \"$CLUSTER\") | .cluster.certificate-authority" "$KUBECONFIG_FILE")
        CA_DATA=""
        if [ -n "$CA_FILE" ] && [ -f "$CA_FILE" ]; then
            CA_DATA=$(base64 -d < "$CA_FILE" | tr -d '\n')
        else
            CA_DATA=$(yq e ".clusters[] | select(.name == \"$CLUSTER\") | .cluster.certificate-authority-data" "$KUBECONFIG_FILE")
        fi

        # Extract client certificate and key
        USER_NAME=$(yq e ".contexts[] | select(.name == \"$CLUSTER\") | .context.user" "$KUBECONFIG_FILE")
        CERT_FILE=$(yq e ".users[] | select(.name == \"$USER_NAME\") | .user.client-certificate" "$KUBECONFIG_FILE")
        KEY_FILE=$(yq e ".users[] | select(.name == \"$USER_NAME\") | .user.client-key" "$KUBECONFIG_FILE")

        CERT_DATA=""
        KEY_DATA=""
        if [ -n "$CERT_FILE" ] && [ -f "$CERT_FILE" ]; then
            CERT_DATA=$(base64 -d < "$CERT_FILE" | tr -d '\n')
        else
            CERT_DATA=$(yq e ".users[] | select(.name == \"$USER_NAME\") | .user.client-certificate-data" "$KUBECONFIG_FILE")
        fi

        if [ -n "$KEY_FILE" ] && [ -f "$KEY_FILE" ]; then
            KEY_DATA=$(base64 -d < "$KEY_FILE" | tr -d '\n')
        else
            KEY_DATA=$(yq e ".users[] | select(.name == \"$USER_NAME\") | .user.client-key-data" "$KUBECONFIG_FILE")
        fi

        # Create cluster JSON object
        NEW_CLUSTER=$(jq -n \
            --arg name "$CLUSTER" \
            --arg server "$SERVER" \
            --arg insecure "false" \
            --arg caData "$CA_DATA" \
            --arg certData "$CERT_DATA" \
            --arg keyData "$KEY_DATA" \
            '{
                name: $name,
                server: $server,
                tlsClientConfig: {
                    insecure: ($insecure == "true"),
                    caData: $caData,
                    certData: $certData,
                    keyData: $keyData
                }
            }')

        # Merge into existing clusters.json
        jq --argjson newCluster "$NEW_CLUSTER" '. + [$newCluster]' "$CLUSTERS_FILE" > tmp.json && mv tmp.json "$CLUSTERS_FILE"

        echo "Added cluster: $CLUSTER"
    done
done

echo "All clusters extracted from kubeconfig and stored in $CLUSTERS_FILE"
