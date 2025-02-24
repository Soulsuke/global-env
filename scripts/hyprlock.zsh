#! /usr/bin/env zsh

### Utility functions
###############################################################################

# Starts hyprlock, managing dunst notifications.
function start_hyprlock()
{
  # Variables:
  local HOST_CONFIG="${HOME}/.config/hypr/hyprlock.conf.hosts/${HOST}.conf"

  # Stop dunst notifications:
  dunstctl set-paused true

  # If we have a per-host configuration, use it:
  if [[ -f "${HOST_CONFIG}" ]]; then
    hyprlock --config "${HOST_CONFIG}"

  # Otherwise, use the default one:
  else
    hyprlock
  fi

  # Start dunst notification again:
  dunstctl set-paused false
}



### Entry point
###############################################################################

# Start hyprlock in the background:
start_hyprlock &

# Give it a second:
sleep 1

# Then dim the screen:
hyprctl dispatch dpms off

