#!/usr/bin/env bash
set -Eeuo pipefail

git add -A
if git diff --cached --quiet; then
    echo "No changes detected, exiting."
    exit 0
fi

nixfmt ./**/*.nix

echo "Home-Manager Rebuilding..."
if ! home-manager switch -b backup &>nixos-switch.log; then
    grep --color error < nixos-switch.log
    exit 1
fi

current=$(home-manager generations | head -n 1 | awk '{ print $1,$2,$3,$4,$5 }')
git commit -am "$current"

if command -v notify-send >/dev/null; then
    notify-send -e "Home-Manager Rebuilt OK!" --icon=software-update-available
else
    echo "Home-Manager Rebuilt OK!"
fi
