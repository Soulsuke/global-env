#! /usr/bin/env zsh

# Kill all previous wallpapers if the user didn't ask for info:
if [[ ! ${1} == "--test" ]]; then
  killall xwinwrap
  sleep 0.3
fi

# Get a list of active monitors and their display settings:
MONITORS=( "${(@f)$(xrandr --listactivemonitors | grep -v "Monitor")}" )

# Iterate over all of them:
for m in $MONITORS; do
  # Extract the monitor's name:
  NAME=`print $m | awk -F' ' '{print $2}' | sed -r 's,[+*],,g'`

  # Extract the monitor's resolution and position:
  RES=`print $m | awk -F' ' '{print $3}' | sed -r 's,/[0-9]+,,g'`

  # Default wallpaper:
  WAL="${HOME}/.config/wallpaper"

  # If there's a personalized wallpaper for this monitor, use it:
  if [[ -d "${HOME}/.config/wallpaper.d" &&
        -f "${HOME}/.config/wallpaper.d/${NAME}"
     ]]; then
    WAL="${HOME}/.config/wallpaper.d/${NAME}"
  fi

  # If the test flag has been given, simply print print out this info:
  if [[ ${1} == "--test" ]]; then
    print "DISPLAY: ${NAME} => ${RES} => ${WAL}"
  # Else, set the wallpaper
  else
    xwinwrap -d -st -sp -nf -ni -ov -g "${RES}" -- \
      mpv -wid WID "${WAL}" --no-osc --no-osd-bar --no-keepaspect \
      --no-input-default-bindings --no-audio --stop-screensaver=no \
      --loop-file --player-operation-mode=cplayer --panscan=1.0 -vo xv \
      &>/dev/null
  fi
done

