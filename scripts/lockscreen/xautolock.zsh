#! /usr/bin/env zsh

# Only do something if the given locker exists:
if [[ -x ~/.scripts/7shi/lockscreen/lockers/${1}.zsh ]]; then
  # Minutes to wait before lock & powersave:
  local MINS=10
  
  # Set X power settings after an additional 30 seconds:
  xset s $(( ${MINS} * 60 + 30 ))
  xset dpms 0 0 $(( ${MINS} * 60 + 30 ))
  
  # Run the real locking command every 15 minutes via xautolock:
  xautolock -time ${MINS} -locker ~/.scripts/7shi/lockscreen/lockers/${1}.zsh
fi

