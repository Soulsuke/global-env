#! /usr/bin/env zsh



###############################################################################
### Variables                                                               ###
###############################################################################
TEXT="${1}"
COLOR_ON="${2}"
COLOR_PAUSED="${3}"
COLOR_OFF="${4}"



###############################################################################
### Functions                                                               ###
###############################################################################

# Prints out dunst status.
function dunst_status()
{
  # Default is notifications are available:
  local COLOR=${COLOR_ON}

  # Dunst isn't available:
  if [[ ! $(command -v dunstctl) ]]; then
    COLOR=${COLOR_OFF}
  # Dunst is paused::
  elif [[ "true" == $(dunstctl is-paused) ]]; then
    COLOR=${COLOR_PAUSED}
  fi

  # Output formatted with polybar colors:
  print "%{F${COLOR}}${TEXT}%{F-}"
}



# Toggles dunst's pause status. 
function dunst_toggle()
{
  if [[ $(command -v dunstctl) ]]; then
    dunstctl set-paused toggle
    dunst_status
  fi
}



# Repeatedly queries for dunst's status.
function dunst_status_repeated()
{
  while; do
    dunst_status
    sleep ${1}
  done
}



###############################################################################
### Entry point                                                             ###
###############################################################################

# USR1 -> toggle pause:
trap dunst_toggle USR1

# Check if dunst's paused every 5 seconds:
dunst_status_repeated 5 & MY_PID=$!

# INT/TERM/QUIT -> stop dunst_status_repeated, so this script will end as well:
trap "kill -9 ${MY_PID}" INT TERM QUIT

# Await for the previous thread to end before quitting:
wait

