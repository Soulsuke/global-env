#! /usr/bin/env zsh

# Variables:
local HOST_CONFIG="${HOME}/.config/waybar/config.jsonc.hosts/${HOST}.jsonc"

# Kill any active instance of waybar:
killall waybar &> /dev/null

# If we have a per-host configuration, use it:
if [[ -f "${HOST_CONFIG}" ]]; then
  waybar --config "${HOST_CONFIG}"

# Otherwise, use the default one:
else
  waybar
fi

