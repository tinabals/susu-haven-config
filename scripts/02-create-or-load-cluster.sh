#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh
require_tool docker
require_tool kind
require_tool kubectl
docker info >/dev/null
docker image inspect susu-haven:dami-v1 susu-haven:dami-v2 >/dev/null
if kind get clusters | grep -Fxq "$LAB_CLUSTER"; then
  printf '%s\n' 'Reusing the existing local cluster; no cluster is deleted.'
else
  kind create cluster --name "$LAB_CLUSTER" --wait 180s
fi
kubectl config use-context "$LAB_CONTEXT"
kind load docker-image susu-haven:dami-v1 susu-haven:dami-v2 --name "$LAB_CLUSTER"
k create namespace "$LAB_NAMESPACE" --dry-run=client -o yaml | k apply -f -
printf '%s\n' 'Both website images are loaded. Next follow SETUP.md for the appropriate existing/new lab path.'
