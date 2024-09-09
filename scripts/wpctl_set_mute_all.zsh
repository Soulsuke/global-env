#! /usr/bin/env zsh

# First argument is either "Sources" or "Sinks":
TYPE_START=${1}
TYPE_END=""
case ${TYPE_START} in
  Sources) TYPE_END="Filters:" ;;
  Sinks)   TYPE_END="Sources:" ;;
  *)       TYPE_END=""         ;;
esac

# Command must be either 0, 1 or 'toggle'.
CMD=${2}

# Start off fetching all available devices and storing them in a handy
# variable:
DEVICES=$(
  wpctl status | \
  awk "BEGIN { is_audio = 0; is_type = 0; }
       /^Audio/ { is_audio = 1; }
       /${TYPE_START}/ { is_type = 1; }
       /${TYPE_END}/ { is_type = 0; }
       /^Video/ { is_audio = 0; }
       {
         if( 1 == is_audio && 1 == is_type && / [[:digit:]]*\./ )
         { print; }
       }"
  )

# Toggle is tricky, because pluggnig/unplugging mics may cause different states
# between devices.
# So:
#  - if one or more devices are muted, we're gonna unmute them all
#  - if no device is muted, we'll mute them all
if [[ ${CMD} == "toggle" ]]; then
  # Use grep to check if any device is muted:
  grep "MUTED" <<< ${DEVICES} &> /dev/null

  # And grep's exit code is the command we're looking for:
  CMD=$?
fi

# Now, run the command on each device:
awk "/│/ {gsub(\"[*.]\",\"\"); system(\"wpctl set-mute \" \$2 \" ${CMD}\")}" \
  <<< ${DEVICES}

