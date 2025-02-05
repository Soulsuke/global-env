#! /usr/bin/env zsh

### Utility functions
###############################################################################

# $1 => screen name
get_wallpaper_for()
{
  # Default wallpaper:
  local RET="${HOME}/.config/wallpaper"

  # If there's per-monitor wallpaper, use it:
  if [[ -f "${HOME}/.config/wallpaper.d/${1}" ]]; then
    RET="${HOME}/.config/wallpaper.d/${1}"
  fi

  # Finally, print out ret:
  print "${RET}"
}



### Entry point
###############################################################################

# Current environment:
ENVIRONMENT="${XDG_SESSION_TYPE:l}"

# Per-environment dependencies:
DEPS=(mpv)
MAIN_LAUNCHER=""
if [[ "${ENVIRONMENT}" == "x11" ]]; then
  MAIN_LAUNCHER="xwinwrap"
  DEPS+=(xrandr)
elif [[ "${ENVIRONMENT}" == "wayland" ]]; then
  MAIN_LAUNCHER="mpvpaper"
  DEPS+=(wlr-randr)
fi
DEPS+=(${MAIN_LAUNCHER})

# Do nothing if any of these are unavailable:
for PR in ${DEPS}; do
  command -v ${PR} &> /dev/null && continue
  print "Executable missing: ${PR}"
  exit 1
done

# Check if we should use prime-run:
command -v prime-run &> /dev/null && PR="prime-run" || PR=""

# X11 logic:
if [[ "${ENVIRONMENT}" == "x11" ]]; then
  # Iterate over all of the available monitors:
  for MONITOR in "${(@f)$(xrandr | grep "\sconnected")}"; do
    # Geometry:
    GEO=`grep -oE '[0-9]+x[0-9]+\+[0-9]+\+[0-9]+' <<< ${MONITOR}`

    # Actual monitor name:
    MONITOR=`awk '{print $1}' <<< ${MONITOR}`

    # Wallpaper to use:
    WAL=$(get_wallpaper_for "${MONITOR}")

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

# Wayland logic:
elif [[ "${ENVIRONMENT}" == "wayland" ]]; then
  # Iterate over all of the available monitors
  for MONITOR in "$(wlr-randr | grep -vE "^ " | sed -e "s, .*,,")"; do
    # Wallpaper to use:
    WAL=$(get_wallpaper_for "${MONITOR}")

    # Set the wallpaper:
    mpvpaper \
      "${MONITOR}" \
      "${WAL}" \
      -f \
      -o "fs hwdec loop-file no-audio no-keepaspect no-osc no-osd-bar panscan=1.0 player-operation-mode=cplayer really-quiet stop-screensaver=no scale=bilinear"
  done

fi

