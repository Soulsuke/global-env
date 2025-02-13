#! /usr/bin/env zsh

case ${HOST} in
  chunchunmaru)
    # Workspace 1:
    cherrytree /home/nanashi/.config/cherrytree/nanashi.ctx &
    vivaldi-stable &
    evolution &
    # Workspace 2:
    wasistlos &
    telegram-desktop &
    if [[ ${XDG_SESSION_TYPE:l} == "wayland" ]]; then
      discord \
        --enable-features=UseOzonePlatform \
        --ozone-platform=wayland \
        --disable-gpu
    else
      discord &
    fi
  ;;

  unmei)
    # Workspace 1:
    cherrytree &
    vivaldi-stable &
    claws-mail &
    # Workspace 2:
    whatsapp-for-linux &
    telegram-desktop &
    # Workspace 10:
    steam &
  ;;

  *)
    notify-send "No common startup applications set."
  ;;
esac

