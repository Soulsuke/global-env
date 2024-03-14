#! /usr/bin/env zsh

# Touchpad id:
ID=$(xinput list | grep -i touchpad | sed -e "s,.*id=,," | awk '{ print $1 }')

# Do nothing if not available:
[[ -z ${ID} ]] && exit

# If enabled, disable it:
if xinput list-props ${ID} | grep -E "Device Enabled.*1$" &> /dev/null; then
  xinput disable ${ID}
# Otherwise, enable it:
else
  xinput enable ${ID}
fi

