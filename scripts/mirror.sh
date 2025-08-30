#!/usr/bin/env bash

URL=$1
DEPTH=$2
DOMAIN=$(echo "$URL" | awk -F/ '{print $3}')

if [ -z "$URL" ]; then
  echo "Usage: $0 <url> [depth]"
  exit 1
fi

# Default depth = inf if not provided
if [ -z "$DEPTH" ]; then
  DEPTH="inf"
fi

wget \
    --recursive \
    --level="$DEPTH" \
    --convert-links \
    --adjust-extension \
    --page-requisites \
    --no-parent \
    --continue \
    --wait=1 \
    --random-wait \
    --limit-rate=2000k \
    --domains="$DOMAIN" \
    "$URL"
