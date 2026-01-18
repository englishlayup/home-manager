#!/usr/bin/env bash
# Find the PIP window address
PIP_WINDOW=$(hyprctl clients -j | jq -r '.[] | select(.title=="Picture in picture") | .address')
hyprctl dispatch setprop address:$PIP_WINDOW opaque toggle > /dev/null
