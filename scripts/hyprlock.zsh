#! /usr/bin/env zsh

# Variables:
local HOST_CONFIG="${HOME}/.config/hypr/hyprlock.conf.hosts/${HOST}.conf"

# If we have a per-host configuration, use it:
if [[ -f "${HOST_CONFIG}" ]]; then
  hyprlock --config "${HOST_CONFIG}"

# Otherwise, use the default one:
else
  hyprlock
fi

