#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
LAB_TOOL="${1:-}"
case "$LAB_TOOL" in
  argo) LAB_CLUSTER=susu-argo-lab ;;
  flux) LAB_CLUSTER=susu-flux-lab ;;
  *) echo 'Usage: bash scripts/02-create-cluster.sh argo|flux'; exit 1 ;;
esac
kind create cluster --name "$LAB_CLUSTER" --wait 120s
kubectl config use-context "kind-$LAB_CLUSTER"
kind load docker-image susu-haven:v1 susu-haven:v2 --name "$LAB_CLUSTER"
kubectl create namespace lab
printf '%s\n' 'Local cluster ready. GitOps is not installed yet.'
