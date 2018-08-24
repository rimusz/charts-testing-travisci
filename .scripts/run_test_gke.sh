#!/bin/bash

set -e

source ${PWD}/cluster

# Set GKE cluster access
gcloud auth activate-service-account --key-file ${PWD}/gcloud-service-key.json
gcloud --quiet config set project $PROJECT_NAME
gcloud --quiet config set compute/zone $CLOUDSDK_COMPUTE_ZONE
gcloud --quiet config set container/cluster $CLUSTER_NAME
gcloud --quiet container clusters get-credentials $CLUSTER_NAME

#echo "Scale up GKE cluster"
#yes | gcloud container clusters resize $CLUSTER_NAME --node-pool default-pool --size 3

#echo "Wait for GKE nodes to be up and ready"
#JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'; until kubectl get nodes -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do sleep 1; done

echo "Run remote charts-testing with install only"
docker run --rm -e KUBECONFIG="/home/travis/.kube/config" -e CHART_DIRS="stable" -v "/home:/home" -v "$(pwd):/workdir" --workdir /workdir gcr.io/kubernetes-charts-ci/chart-testing:${CHART_TESTING_VERSION} chart_test.sh --no-lint

#echo "Scale down GKE cluster"
#yes | gcloud container clusters resize $CLUSTER_NAME --node-pool default-pool --size 1
