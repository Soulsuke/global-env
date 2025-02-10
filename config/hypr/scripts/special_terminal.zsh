#! /usr/bin/env zsh

# Class name to use:
local CLASS="nns.special.terminal"

# Special workspace name:
local WORKSPACE_NAME="terminal"

# If there's already an instance running, just switch to the workspace:
if [[ $(hyprctl clients | grep "class: ${CLASS}") ]]; then
  hyprctl dispatch togglespecialworkspace "${WORKSPACE_NAME}"

# Otherwise, start terminology and move to it:
else
  hyprctl dispatch exec "kitty --class ${CLASS}"
fi

