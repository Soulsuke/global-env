#! /usr/bin/env zsh


# Terminate any currently running instances:
killall -q polybar

# Pause while killall completes:
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# Launch all bars starting with the given name:
cd ${HOME}/.config/polybar/bars

# If multiple bars exist:
if [[ -e "${1}.d" ]]; then
  cd "${1}.d"
  for bar in *; do
    polybar -c ${HOME}/.config/polybar/config "${1}_${bar}" &
  done

# If it's just a single bar:
else
  polybar -c ${HOME}/.config/polybar/config "${1}" & 
fi

