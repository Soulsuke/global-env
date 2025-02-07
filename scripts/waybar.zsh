#! /usr/bin/env zsh

# This is a workaround until waybar will support imports.

# Variables:
local CONFIG="${HOME}/.config/waybar/config.jsonc"
local PER_HOST_BASE="${HOME}/.config/waybar/00-per_host"
local PER_HOST="${PER_HOST_BASE}/${HOST}.jsonc"
local DEFAULT="${PER_HOST_BASE}/00-default.jsonc"

# Kill any active instance of waybar:
killall waybar

# Remove the default config file:
rm "${CONFIG}" &> /dev/null

# If we have a per host file, link it:
if [[ -f "${PER_HOST}" ]]; then
  ln -s "${PER_HOST}" "${CONFIG}"

# Otherwise, link the default:
else
  ln -s "${DEFAULT}" "${CONFIG}"
fi

# Finally, start waybar:
waybar

