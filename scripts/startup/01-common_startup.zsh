#! /usr/bin/env zsh

case ${HOST} in
  chunchunmaru)
    # Screen 1:
    cherrytree /home/nanashi/data/nextcloud/cherrytree/nanashi.ctx &
    cherrytree /home/nanashi/data/nextcloud/cherrytree/dotvocal.ctx &
    vivaldi-stable &
    evolution &
    # Screen 2:
    rambox &
    telegram-desktop &
    discord-canary &
    ~/.nativefier/DotSwitch-linux-x64/DotSwitch &
    # No particular screen:
    nextcloud &
  ;;

  unmei)
    cherrytree &
    claws-mail &
    rambox &
    signal-desktop &
    steam-native &
    telegram-desktop &
    vivaldi-stable &
  ;;

  *)
    notify-send 'No common startup applications set.'
  ;;
esac

