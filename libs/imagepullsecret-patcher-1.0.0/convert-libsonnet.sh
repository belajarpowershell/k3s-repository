# Convert values.yaml to json
yq -o json values.yaml > values-temp.libsonnet
yq -o json Chart.yaml > chart-temp.libsonnet
# Run jsonnetfmt on the file

jsonnetfmt values-temp.libsonnet > values.libsonnet
jsonnetfmt chart-temp.libsonnet > chart.libsonnet

rm values-temp.libsonnet

rm chart-temp.libsonnet

