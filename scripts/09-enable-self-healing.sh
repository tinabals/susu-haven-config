#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh
require_lab
k -n argocd patch application "$LAB_APP" --type merge -p '{"spec":{"syncPolicy":{"automated":{"enabled":true,"selfHeal":true,"prune":false}}}}'
printf '%s\n' 'Automated sync and self-healing enabled; pruning is disabled for this lab.' 'Wait for the current Git baseline to be Synced and Healthy before changing the live count.'
