#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh
require_lab
k -n argocd patch application "$LAB_APP" --type merge -p '{"spec":{"syncPolicy":{"automated":null}}}'
k -n argocd get application "$LAB_APP" -o jsonpath='{.spec.syncPolicy}{"\n"}'
printf '%s\n' 'Auto-sync is disabled. This did not change Git or synchronize the application.'
