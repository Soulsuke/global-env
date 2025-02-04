#!/usr/bin/env zsh

# Config reader:
source ~/.scripts/7shi/lib/load_conf.zsh

# Rofi options container:
roficmds=()

# Current DE container:
local DE="${XDG_SESSION_DESKTOP:l}"

# Fetch the lockscreen command for the current de:
LOCK_COMMAND="$(7shi_load_conf ~/.config/7shi/rofi_sessionmgr "locker_${DE}")"

# Add it in only if present:
[[ -z "${LOCK_COMMAND}" ]] || roficmds+=( 'Lock screen' "${LOCK_COMMAND}" )

# The logout command depends on the current DE:
LOGOUT_CMD=""
case "${DE}" in
  i3) LOGOUT_CMD='i3-msg exit' ;;
  hyprland) LOGOUT_CMD='hyprctl dispatch exit' ;;
esac

# Add it in only if present:
[[ -z "${LOGOUT_CMD}" ]] || roficmds+=( 'Logout' "${LOGOUT_CMD}" )

# These should always be present:
roficmds+=(
  'Reboot'         'reboot'
  'Shutdown'       'shutdown -h now'
  'Suspend to ram' 'systemctl suspend'
)

# If no parameters have been given, print the menu:
if [[ 0 == ${#@} ]]; then
  # Keys to print are those at even indexes:
  for (( i = 1; i <= ${#roficmds}; i++ )) do
    if [[ 1 == $(( ${i} % 2 )) ]]; then
      print ${roficmds[i]}
    fi
  done

# Else let's evaluate $1:
else
  # Rofi will keep focus until closed, and any spawned window will prevent it
  # from doing so. Thus, let's be sure it dies swiftly:
  killall rofi &> /dev/null

  # Execute the chosen command, which is stored in roficmds at the index of
  # $1 + 1:
  eval ${roficmds[roficmds[(i)$1]+1]}
fi

