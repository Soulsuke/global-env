#! /usr/bin/env zsh

# If it's running:
if pidof wf-recorder &> /dev/null ; then
  # Set the "stop recording" icon:
  print 

  # And stop recording:
  if [[ ${1} == "toggle" ]]; then
    kill "$(pidof wf-recorder)" &> /dev/null
  fi

# If it isn't running:
else
  # Set the "start recording" icon:
  print 

  # And start recording:
  if [[ ${1} == "toggle" ]]; then
    wf-recorder \
      -a \
      -g "$(slurp)" \
      -y \
      -f "$(xdg-user-dir VIDEOS)/wf-recorder_$(date "+%Y-%m-%d_%H-%M-%S").mkv" \
      &> /dev/null &
  fi
fi

