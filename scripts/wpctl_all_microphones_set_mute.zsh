#! /usr/bin/env zsh

# Command must be either 0, 1 or 'toggle'.
CMD=${1}

# Toggle is tricky, because pluggnig/unplugging mics may cause different states
# between devices. So:
if [[ ${CMD} == "toggle" ]]; then
  # If the main device is muted, unmute everything:
  if wpctl status | grep -E '\*.*Microphone.*MUTED' &> /dev/null; then
    CMD=0
  # Otherwise, mute everything:
  else
    CMD=1
  fi
fi

# Set the state for all devices:
wpctl status | grep Microphone | \
  awk "/│/ {gsub(\"[*.]\",\"\"); system(\"wpctl set-mute \" \$2 \" ${CMD}\")}"

