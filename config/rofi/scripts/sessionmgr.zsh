#!/usr/bin/env zsh

# Logout command depending on the current de:
LOGOUT_CMD=""
case ${GDMSESSION:l} in
  i3) LOGOUT_CMD='i3-msg exit' ;;
esac

# Config reader:
source ~/.scripts/7shi/lib/load_conf.zsh

# Commands to execute in an ordered array which will be used as a sort of hash:
roficmds=(
  'Lock screen'    "$(7shi_load_conf ~/.config/7shi/rofi_sessionmgr locker)"
  'Logout'         "${LOGOUT_CMD}"
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

