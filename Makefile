# Lint charts locally
CHART_TESTING_TAG ?= v1.0.3
CHARTS_REPO ?= https://github.com/rimusz/charts-testing-travisci
#TRAVISCI_RUN ?= false

.PHONY: lint
lint:
	$(eval export CHART_TESTING_TAG)
	$(eval export CHARTS_REPO)
	#$(eval export TRAVISCI_RUN)
	test/lint-charts.sh
