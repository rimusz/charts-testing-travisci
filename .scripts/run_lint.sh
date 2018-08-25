#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly IMAGE_TAG=${TEST_IMAGE_TAG}
readonly IMAGE_REPOSITORY="gcr.io/kubernetes-charts-ci/chart-testing"
readonly REPO_ROOT="${REPO_ROOT:-$(git rev-parse --show-toplevel)}"

git remote add k8s ${CHARTS_REPO}
git fetch k8s master
docker run --rm -v "$REPO_ROOT:/workdir" --workdir /workdir "$IMAGE_REPOSITORY:$IMAGE_TAG" chart_test.sh --no-install --config /workdir/test/.testenv
echo "Done Testing!"
