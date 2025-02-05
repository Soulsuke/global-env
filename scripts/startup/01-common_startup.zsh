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
    XDG_SESSION_TYPE=x11 discord &
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
    notify-send 'No common startup applications set.'
  ;;
esac

