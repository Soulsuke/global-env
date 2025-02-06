#! /usr/bin/env zsh

###############################################################################
### Startup programs                                                        ###
###############################################################################

# Common startup commands for X11 sessions (before any compositor):
if [[ ${XDG_SESSION_TYPE:l} == "x11" ]]; then
  [[ $(command -v nvidia-settings) ]] && nvidia-settings -l
  ibus-daemon -drx
fi

# This should be done under wayland too, so xwayland apps look right:
if [[ $(command -v xrdb) ]] && [[ -f ${HOME}/.Xresources ]]; then
  xrdb -merge ${HOME}/.Xresources
fi

# DE specific. Possible values:
# cinnamon
# cinnamon2d
# enlightenment
# gnome
# gnome-cassic
# hyprland
# i3
# plasma
# plasmawayland
# xfce
case ${XDG_SESSION_DESKTOP:l} in
  enlightenment)
    blueman-applet &
    gkrellm &
    pasystray &
    tilda &
  ;;

  i3)
    picom --config ~/.config/i3/picom --daemon
    ~/.scripts/7shi/wallpaper.zsh &
    ~/.scripts/7shi/lockscreen/xautolock.zsh i3lock &
    dunst -config ~/.config/dunst/dunstrc_x11 &
    blueman-applet &
    nm-applet &
    tilda &
  ;;

  plasmawayland)
    yakuake &
  ;;

  hyprland)
    ~/.scripts/7shi/wallpaper.zsh &
    dunst -config ~/.config/dunst/dunstrc_wayland &
    blueman-applet &
    nm-applet &
    tilda --dbus &
  ;;

  *)
    gkrellm &
    pasystray &
    tilda &
  ;;
esac



# Common for Every DE, after the compositor is in place:
gnome-keyring-daemon --start
redshift-gtk &
[[ $(command -v akbl) ]] && akbl --start-indicator &
${HOME}/.scripts/7shi/wpctl_set_mute_all.zsh Sources 0
${HOME}/.scripts/7shi/wpctl_set_mute_all.zsh Sinks 0

