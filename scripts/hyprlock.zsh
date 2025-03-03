#! /usr/bin/env zsh

### Utility functions
###############################################################################

# Starts hyprlock, managing dunst notifications.
function start_hyprlock()
{
  # Variables:
  local HOST_CONFIG="${HOME}/.config/hypr/hyprlock.conf.hosts/${HOST}.conf"

  # If we have a per-host configuration, use it:
  if [[ -f "${HOST_CONFIG}" ]]; then
    hyprlock --config "${HOST_CONFIG}"

  # Otherwise, use the default one:
  else
    hyprlock
  fi

  # This gets called only when hyprlock has effectively stopped.
  # Restore dunst notifications:
  dunstctl set-paused false
}



### Entry point
###############################################################################

# Disable dunst notifications:
dunstctl set-paused true

# Start hyprlock in the background, only if it isn't already running:
pidof hyprlock || start_hyprlock &

# Give it a second:
sleep 1

# Then dim the screen:
hyprctl dispatch dpms off

