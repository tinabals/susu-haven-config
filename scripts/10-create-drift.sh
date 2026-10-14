#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh
require_lab
k -n "$LAB_NAMESPACE" scale deployment/"$LAB_APP" --replicas=5
k -n "$LAB_NAMESPACE" get deployment "$LAB_APP" -o jsonpath='{.spec.replicas}{"\n"}'
printf '%s\n' 'Only the live Deployment was changed. Git was not edited.' 'With self-healing enabled, the requested count may already return to 3. Watch it in Argo CD or the terminal.'
