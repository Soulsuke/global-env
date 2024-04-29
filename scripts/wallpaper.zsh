#! /usr/bin/env zsh

# Do nothing if any of these are unavailable:
for PR in xwinwrap mpv; do
  command -v ${PR} &> /dev/null && continue
  print "Executable missing: ${PR}"
  exit 1
done

# Check if this is a test scenario:
[[ "--test" == ${1} ]] && TEST=1 || TEST=0

# Kill all previous wallpapers only in a non-test scenario:
(( 0 == TEST )) && killall xwinwrap && sleep 0.3

# Check if we should use prime-run:
command -v prime-run &> /dev/null && PR="prime-run" || PR=""

# Iterate over all of the available monitors:
for MONITOR in "${(@f)$(xrandr | grep "\sconnected")}"; do
  # Geometry:
  GEO=`print ${MONITOR} | awk '{print $4}'`

  # Actual monitor name:
  MONITOR=`print ${MONITOR} | awk '{print $1}'`

  # Default wallpaper:
  WAL="${HOME}/.config/wallpaper"

  # If there's per-monitor wallpaper, use it:
  if [[ -f "${HOME}/.config/wallpaper.d/${MONITOR}" ]]; then
    WAL="${HOME}/.config/wallpaper.d/${MONITOR}"
  fi

  # If the test flag has been given, just print out this info:
  if (( 1 == TEST )); then
    print "${MONITOR} ${GEO} ${WAL}"
    continue
  fi

  # Start mpv via xwinwrap using options:
  #   -d  => Daemonize
  #   -st => Skip Taskbar
  #   -sp => Skip Pager
  #   -nf => No Focus
  #   -ni => Ignore Input
  #   -ov => Set override_redirect flag
  #   -g  => Specify Geometry (eg. 640x480+100+100)
  xwinwrap -d -st -sp -nf -ni -ov -g ${GEO} -- \
    ${PR} mpv -wid WID "${WAL}" \
      --fs \
      --hwdec \
      --loop-file \
      --no-audio \
      --no-keepaspect \
      --no-osc \
      --no-osd-bar \
      --panscan=1.0 \
      --player-operation-mode=cplayer \
      --really-quiet \
      --stop-screensaver=no
done

