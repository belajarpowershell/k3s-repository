#!/bin/bash

# Convert values.yaml to json
for file in manifests/helm-manifests/imagepullsecret-patcher/templates/*.yaml; do
    base_name=$(basename "$file" .yaml)
    yq -o json "$file" > "manifests/helm-manifests/imagepullsecret-patcher/templates/${base_name}-temp.libsonnet"
done

# Run jsonnetfmt on the file
for file2 in manifests/helm-manifests/imagepullsecret-patcher/templates/*-temp.libsonnet; do
    base_name2=$(basename "$file2" -temp.libsonnet)
    jsonnetfmt "$file2" > "manifests/helm-manifests/imagepullsecret-patcher/templates/${base_name2}.libsonnet"
   # echo "jsonnetfmt "$file2" > "manifests/helm-manifests/imagepullsecret-patcher/templates/${base_name2}.libsonnet""
done

for file2 in manifests/helm-manifests/imagepullsecret-patcher/templates/*-temp.libsonnet; do
    base_name2=$(basename "$file2" -temp.libsonnet)
    rm "$file2" 
   # echo "jsonnetfmt "$file2" > "manifests/helm-manifests/imagepullsecret-patcher/templates/${base_name2}.libsonnet""
done
