#! /usr/bin/env zsh



###############################################################################
### Environment variables                                                   ###
###############################################################################

# Locale:
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# GTK dialogues in telegram-desktop:
export QT_QPA_PLATFORMTHEME=gtk3



###############################################################################
### ibus                                                                    ###
###############################################################################

# export GTK_IM_MODULE=ibus
# export QT_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# ibus-daemon -drx



###############################################################################
### Startup programs                                                        ###
###############################################################################

# Common for every DE, before an eventual compositor is started:
xrandr --dpi 100
setxkbmap it
[[ $(command -v nvidia-settings) ]] && nvidia-settings -l



# DE specific. Possible values:
# cinnamon
# cinnamon2d
# enlightenment
# gnome
# gnome-cassic
# i3
# plasma
# plasmawayland
# xfce
case ${GDMSESSION:l} in
  enlightenment)
    blueman-applet &
    gkrellm &
  ;;

  i3)
    picom --config ~/.config/i3/picom --daemon
    ${HOME}/.scripts/7shi/lockscreen/xautolock.zsh i3lock
    ${HOME}/.scripts/7shi/wallpaper.zsh
    dunst &
    blueman-applet &
    nm-applet &
  ;;

  plasmawayland)
    yakuake &
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
[[ $(command -v akbl) ]] && akbl --start-indicator &

