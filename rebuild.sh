#!/usr/bin/env bash
set -e
if git diff --quiet; then
    echo "No changes detected, exiting."
    exit 0
fi
nixfmt ./**/*.nix &>/dev/null \
  || ( nixfmt . ; echo "formatting failed!" && exit 1)
git diff -U0 ./*.nix
echo "Home-Manager Rebuilding..."
# shellcheck disable=SC2024
home-manager switch &>nixos-switch.log || (
grep --color error < nixos-switch.log  && exit 1)
current=$(home-manager generations | head -n 1 | awk '{ print $1,$2,$3,$4,$5 }')
git commit -am "$current"
command -v notify-send >/dev/null && notify-send -e "Home-Manger Rebuilt OK!" --icon=software-update-available || echo "Home-Manager Rebuilt OK!"
