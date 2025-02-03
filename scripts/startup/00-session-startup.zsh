#! /usr/bin/env zsh

# Let's be extra sure to source this:
[[ -f ${HOME}/.profile ]] && source ${HOME}/.profile



###############################################################################
### Startup programs                                                        ###
###############################################################################

# Common for every DE, before an eventual compositor is started:
[[ $(command -v nvidia-settings) ]] && nvidia-settings -l
ibus-daemon -drx

# This should only happen for X11 sessions:
if [[ ${XDG_SESSION_TYPE:l} == "x11" ]]; then
  [[ -f ${HOME}/.Xresources ]] && xrdb -merge ${HOME}/.Xresources
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
  ;;

  i3)
    picom --config ~/.config/i3/picom --daemon
    ~/.scripts/7shi/wallpaper.zsh &
    ~/.scripts/7shi/lockscreen/xautolock.zsh i3lock &
    dunst &
    blueman-applet &
    nm-applet &
  ;;

  plasmawayland)
    yakuake &
  ;;

  hyprland)
    # TODO
  ;;

  *)
    gkrellm &
    pasystray &
  ;;
esac



# Common for Every DE, after the compositor is in place:
gnome-keyring-daemon --start
redshift-gtk &
tilda &
[[ $(command -v akbl) ]] && akbl --start-indicator &
${HOME}/.scripts/7shi/wpctl_set_mute_all.zsh Sources 0
${HOME}/.scripts/7shi/wpctl_set_mute_all.zsh Sinks 0

