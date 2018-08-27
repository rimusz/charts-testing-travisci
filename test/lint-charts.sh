#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly IMAGE_TAG=${CHART_TESTING_TAG}
readonly IMAGE_REPOSITORY="gcr.io/kubernetes-charts-ci/chart-testing"
readonly REPO_ROOT="${REPO_ROOT:-$(git rev-parse --show-toplevel)}"

main() {
    if git remote | grep k8s > /dev/null; then
      echo "Remote k8s already exists"
    else
      git remote add k8s ${CHARTS_REPO}
    fi
    mkdir -p tmp
    docker run --rm -v "$(pwd):/workdir" --workdir /workdir "$IMAGE_REPOSITORY:$IMAGE_TAG" chart_test.sh --no-install --config /workdir/test/.testenv | tee tmp/lint.log
    if cat tmp/lint.log | grep "No chart changes detected" > /dev/null; then
      echo "Nothing to lint"
      if [[ "${TRAVISCI_RUN}" = "true" ]]; then
        echo "travis_terminate 0"
      fi
    fi
    echo "Done Linting!"
}

main
