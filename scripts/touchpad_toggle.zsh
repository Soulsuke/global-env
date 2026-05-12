#! /usr/bin/env zsh



### Utility functions
###############################################################################

# This works on every X11 environment.
# No parameters needed.
function toggle_x11
{
  # Touchpad id:
  local ID=$(
    xinput list | \
    grep -i touchpad | \
    sed -e "s,.*id=,," | \
    awk '{ print $1 }'
  )

  # Do nothing if not available:
  [[ -z ${ID} ]] && exit 1

  # If enabled, disable it:
  if xinput list-props ${ID} | grep -E "Device Enabled.*1$" &> /dev/null; then
    xinput disable ${ID}
  # Otherwise, enable it:
  else
    xinput enable ${ID}
  fi
}



# This works on hyprland.
function toggle_hyprland
{
  # Touchpad device:
  local TOUCHPAD=$(hyprctl devices | grep touchpad | sed -e "s,\s,,g")

  # Do nothing if not available:
  [[ -z ${TOUCHPAD} ]] && exit 1

  # Disabled status keyword:
  local KW="input:touchpad:disable_while_typing"

  # If it's not disabled yet, disable it:
  if [[ -z "$(hyprctl getoption "${KW}" | grep "bool: true")" ]]; then
    hyprctl eval \
      "hl.device({ name = \"${TOUCHPAD}\", enabled = false })" \
      &> /dev/null
    hyprctl eval \
      'hl.config({ input = { touchpad = { disable_while_typing = true } } })' \
      &> /dev/null

  # Otherwise, disable it:
  else
    hyprctl eval \
      "hl.device({ name = \"${TOUCHPAD}\", enabled = true })" \
      &> /dev/null
    hyprctl eval \
      'hl.config({input = { touchpad = { disable_while_typing = false } }})' \
      &> /dev/null
  fi
}



### Entry point
###############################################################################

# On X11 it's easy:
if [[ ${XDG_SESSION_TYPE:l} == "x11" ]]; then
  toggle_x11
  exit 0
fi

# Otherwise, check all supported environments:
case ${XDG_SESSION_DESKTOP:l} in
  hyprland) toggle_hyprland ;;

  *)
    print "UNSUPPORTED!"
    exit 1
  ;;

esac

