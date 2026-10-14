#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh
require_tool docker
docker info >/dev/null
docker build --build-arg SITE_FILE=index.html -t susu-haven:dami-v1 .
docker build --build-arg SITE_FILE=index-v2.html -t susu-haven:dami-v2 .
printf '%s\n' 'Built susu-haven:dami-v1 and susu-haven:dami-v2. No cluster has been changed.'
