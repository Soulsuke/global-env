#! /usr/bin/env zsh

# If no config name has been given, user the current hostname:
[[ ! -z ${1} ]] && CONFIG_NAME=${1} || CONFIG_NAME=${HOST}

# Terminate any currently running instances:
killall -q polybar

# Pause while killall completes:
while pgrep -u ${UID} -x polybar > /dev/null; do sleep 1; done

# Launch all bars starting with the given name:
cd ${HOME}/.config/polybar/bars

# If multiple bars exist:
if [[ -d "${CONFIG_NAME}.d" ]]; then
  cd "${CONFIG_NAME}.d"
  for bar in *; do
    # Monitor the bar is supposed to connect to:
    MON=`grep monitor "${bar}" | sed -e "s,.* ,,"`

    # Only move forward if either MON is empty or it is detected by xrandr:
    if [[ -z ${MON} ]] ||
       [[ ! -z `xrandr | grep "\sconnected" | grep ${MON}` ]]
    then
      polybar -c ${HOME}/.config/polybar/config "${CONFIG_NAME}_${bar}" &
    fi
  done

# If it's just a single bar:
else
  polybar -c ${HOME}/.config/polybar/config "${CONFIG_NAME}" &
fi

