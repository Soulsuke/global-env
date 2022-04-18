#! /usr/bin/env zsh

# Common for every DE, before an eventual compositor:
xrandr --dpi 100
setxkbmap it
ibus-daemon -drx
case ${HOST} in
  chunchunmaru)
    nvidia-settings -l
  ;;
  unmei)
    nvidia-settings -l
  ;;
esac



# DE specific. Possible values:
# cinnamon
# cinnamon2d
# enlightenment
# gnome
# gnome-cassic
# i3
# plasma
# xfce
case ${GDMSESSION:l} in
  enlightenment)
    blueman-applet &
    gkrellm &
    ;;
  i3)
    picom --config ~/.config/i3/picom -bG
    ${HOME}/.scripts/7shi/lockscreen/xautolock.zsh i3lock
    ${HOME}/.scripts/7shi/wallpaper.zsh
    dunst &
    blueman-applet &
    nm-applet &
    ;;
  *)
    gkrellm &
    ;;
esac



# Common for Every DE, after the compositor is in place:
gnome-keyring-daemon --start
pasystray &
redshift-gtk &
tilda &
case ${HOST} in
  chunchunmaru)
    optimus-manager-qt &
  ;;
  unmei)
    akbl --start-indicator &
  ;;
esac

