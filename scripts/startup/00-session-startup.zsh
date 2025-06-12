#! /usr/bin/env zsh

###############################################################################
### Startup programs                                                        ###
###############################################################################

# Common startup commands for X11 sessions (before any compositor):
if [[ ${XDG_SESSION_TYPE:l} == "x11" ]]; then
  [[ $(command -v nvidia-settings) ]] && nvidia-settings -l
fi

# This works much better than ibus:
[[ $(command -v fcitx5) ]] && fcitx5 -d --replace

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
    picom --config ${HOME}/.config/i3/picom --daemon
    ${HOME}/.scripts/7shi/wallpaper.zsh &
    ${HOME}/.scripts/7shi/lockscreen/xautolock.zsh i3lock &
    ${HOME}/.scripts/7shi/dunst.zsh &
    blueman-applet &
    nm-applet &
    tilda &
  ;;

  plasmawayland)
    yakuake &
  ;;

  hyprland)
    dbus-update-activation-environment \
      --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    ${HOME}/.scripts/7shi/waybar.zsh &
    ${HOME}/.scripts/7shi/wallpaper.zsh &
    ${HOME}/.scripts/7shi/dunst.zsh &
    blueman-applet &
    nm-applet &
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
${HOME}/.scripts/7shi/wpctl_set_mute_all.zsh Sources 1
${HOME}/.scripts/7shi/wpctl_set_mute_all.zsh Sinks 0

