#! /usr/bin/env zsh

case ${HOST} in
  chunchunmaru)
    # Workspace 1:
    cherrytree /home/nanashi/.config/cherrytree/nanashi.ctx &
    vivaldi-stable &
    evolution &
    # Workspace 2:
    rambox &
    telegram-desktop &
    discord-canary &
  ;;

  unmei)
    # Workspace 1:
    cherrytree &
    vivaldi-stable &
    claws-mail &
    # Workspace 2:
    rambox &
    telegram-desktop &
    # Workspace 10:
    steam-native &
  ;;

  *)
    notify-send 'No common startup applications set.'
  ;;
esac

