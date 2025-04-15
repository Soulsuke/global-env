#! /usr/bin/env zsh

# If it's running:
if pidof wf-recorder &> /dev/null ; then
  # Set the "stop recording" icon:
  print '{ "text": "", "class": "recording" }'

  # And stop recording:
  if [[ ${1} == "toggle" ]]; then
    kill "$(pidof wf-recorder)" &> /dev/null
  fi

# If it isn't running:
else
  # Set the "start recording" icon:
  print '{ "text": "", "class": "idle" }'

  # And start recording:
  if [[ ${1} == "toggle" ]]; then
    # Let's use a unique sink name:
    local SINK="wf_recorder_$(date "+%s")"

    # Create a composite sink for wf-recorder:
    pw-loopback \
      -m "[ FL FR FC LFE RL RR ]" \
      --capture-props="media.class=Audio/Sink node.name=${SINK}" \
      --playback-props='target.object="my-default-sink"' &

    # Get its pid:
    local LOOPBACK=$!

    # Encopder to use, depending on the host.
    local ENC="hevc_vaapi"
    if [[ ${HOST} == "unmei" ]]; then
      ENC="libx265"
    fi

    # Start recording the screen:
    #   -a -> audio sink name
    #   -C -> audio codec
    #   -c -> video codec
    #   -g -> screen area to record
    #   -y -> force overwrite if file exists (should never happen, buuuuut...)
    #   -f -> output file name
    wf-recorder \
      -a "${SINK}" \
      -C ac3_fixed \
      -c "${ENC}" \
      -g "$(slurp)" \
      -y \
      -f "$(xdg-user-dir VIDEOS)/wf-recorder_$(date "+%Y-%m-%d_%H-%M-%S").mkv"

    # Once the recording ends, stop the loopback:
    kill ${LOOPBACK}
  fi
fi

