#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh
require_lab
require_tool kind
require_tool git
k -n "$LAB_NAMESPACE" get deployment "$LAB_APP"
k -n "$LAB_NAMESPACE" get pods -l app="$LAB_APP"
k -n argocd get application "$LAB_APP" -o jsonpath='{.spec.source.repoURL}{"\n"}{.spec.source.targetRevision}{"\n"}{.spec.source.path}{"\n"}{.status.sync.status}{" / "}{.status.health.status}{"\n"}{.spec.syncPolicy}{"\n"}'
printf '\n%s\n' 'Live replicas and image:'
k -n "$LAB_NAMESPACE" get deployment "$LAB_APP" -o jsonpath='{.spec.replicas}{" / "}{.spec.template.spec.containers[0].image}{"\n"}'
printf '\n%s\n' 'Working tree (an empty result means clean):'
git status --short
printf '\n%s\n' 'Before presenting: Git requests 3 replicas and susu-haven:dami-v1; Argo is Synced and Healthy; auto-sync is disabled for experiment 1.' 'This report does not change anything or prove the Git baseline. Check the committed manifest in GitHub.'
