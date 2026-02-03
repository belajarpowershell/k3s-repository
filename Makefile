.PHONY: help generate-manifests generate-all commit-manifests setup-hooks clean

help:
	@echo "Available targets:"
	@echo "  generate-manifests CLUSTER=<name>  - Generate manifests for a specific cluster (default: k3s-master)"
	@echo "  generate-all                       - Generate manifests for all clusters"
	@echo "  commit-manifests CLUSTER=<name>    - Generate and commit manifests"
	@echo "  setup-hooks                        - Setup git pre-commit hook"
	@echo "  apply-manifests CLUSTER=<name>     - Apply generated manifests to cluster"
	@echo "  clean                              - Clean generated manifests"

CLUSTER ?= k3s-master
LIBS_DIR := libs
CLUSTERS_DIR := clusters
MANIFESTS_DIR := generated-manifests

generate-manifests:
	@echo "Generating manifests for $(CLUSTER)..."
	@mkdir -p $(MANIFESTS_DIR)
	@jsonnet -J $(LIBS_DIR) $(CLUSTERS_DIR)/$(CLUSTER)/apps.jsonnet > $(MANIFESTS_DIR)/$(CLUSTER)-apps.yaml
	@echo "✓ Generated: $(MANIFESTS_DIR)/$(CLUSTER)-apps.yaml"

generate-all:
	@for cluster in $(CLUSTERS_DIR)/*; do \
		if [ -d "$$cluster" ]; then \
			cluster_name=$$(basename $$cluster); \
			echo "Generating manifests for $$cluster_name..."; \
			mkdir -p $(MANIFESTS_DIR); \
			jsonnet -J $(LIBS_DIR) $(CLUSTERS_DIR)/$$cluster_name/apps.jsonnet > $(MANIFESTS_DIR)/$$cluster_name-apps.yaml || exit 1; \
			echo "✓ Generated: $(MANIFESTS_DIR)/$$cluster_name-apps.yaml"; \
		fi; \
	done

commit-manifests: generate-manifests
	@bash scripts/generate-and-commit-manifests.sh $(CLUSTER) main

setup-hooks:
	@echo "Setting up pre-commit hook..."
	@chmod +x scripts/pre-commit
	@cp scripts/pre-commit .git/hooks/pre-commit
	@echo "✓ Pre-commit hook installed"

apply-manifests: generate-manifests
	@echo "Applying manifests for $(CLUSTER)..."
	@kubectl apply -f $(MANIFESTS_DIR)/$(CLUSTER)-apps.yaml -n argocd

clean:
	@echo "Cleaning generated manifests..."
	@rm -rf $(MANIFESTS_DIR)
	@echo "✓ Cleaned"
