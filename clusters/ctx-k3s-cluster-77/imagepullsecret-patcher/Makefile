build:
	rm -rf ./charts values.yaml Charts.yaml requirements.lock
	jsonnet -m . helm-chart.libsonnet && helm dependency build && [ -d "./templates" ] && jsonnet ./templates/_templates.jsonnet > ./templates/templates.yaml
	exit 0

test:
	helm template test .

generate:
	helm template cert-manager . > ../../../generated/clusters/se-11g-aks-dev-01/cert-manager/app.yaml