#! /usr/bin/env zsh

# This is a workaround due to how dunst works on wayland with exclusive areas.

# Variables:
local CONFIG="${HOME}/.cache/wal/dunstrc"

# Sed data depending on the environment:
if [[ ${XDG_SESSION_TYPE:l} == "wayland" ]]; then
  sed -i "s;offset =.*;offset = (0, 0);" "${CONFIG}"
else
  sed -i "s;offset =.*;offset = (0, 28);" "${CONFIG}"
fi

# Kill all running instances:
killall dunst &> /dev/null

# Then start it:
[[ $(command -v dunst) ]] && dunst

