#! /usr/bin/env zsh



###############################################################################
### Environment variables                                                   ###
###############################################################################

# Locale:
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# GTK theme in qt apps:
export QT_QPA_PLATFORMTHEME=gtk3



###############################################################################
### ibus                                                                    ###
###############################################################################

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
ibus-daemon -drx



###############################################################################
### DPI settings                                                            ###
###############################################################################

export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1
export GDK_SCALE=1
export GDK_DPI_SCALE=1.0
xrdb -merge ${HOME}/.Xresources



###############################################################################
### Startup programs                                                        ###
###############################################################################

# Common for every DE, before an eventual compositor is started:
[[ $(command -v nvidia-settings) ]] && nvidia-settings -l



# Let's take the current session name from the right variable:
local NNS_SESSION
for NNS_SESSION in \
  "${XDG_SESSION_DESKTOP}" "${GDMSESSION}" "${XDG_CURRENT_DESKTOP}"
do
  [[ -z ${NNS_SESSION} ]] || break
done



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
case ${NNS_SESSION:l} in
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

