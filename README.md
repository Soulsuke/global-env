# global-env

A global environment for multiple machines, because why should I manage
dotfiles like everyone else when I can reinvent a square-looking wheel?!  

Table of contents:  
<!-- vim-markdown-toc GFM -->

- [Disclaimer](#disclaimer)
- [General info](#general-info)
- [Notes](#notes)
    - [Gnome keyring](#gnome-keyring)
    - [Hyprland](#hyprland)
        - [Packages to install](#packages-to-install)
        - [Issues with Lightdm (connected input devices not working)](#issues-with-lightdm-connected-input-devices-not-working)
        - [Prevent lid closure from suspending to ram](#prevent-lid-closure-from-suspending-to-ram)
        - [Issues with screen sharing](#issues-with-screen-sharing)
        - [Have chrome-based browsers run on wayland instead of xwayland](#have-chrome-based-browsers-run-on-wayland-instead-of-xwayland)
    - [Input methods](#input-methods)
    - [UFW](#ufw)
    - [Xorg nvidia config](#xorg-nvidia-config)

<!-- vim-markdown-toc -->



## Disclaimer

Some of these files date back to 2006ish when I got introduced to Gentoo/kBSD,
and they've followed me on FreeBSD 6, OpenSolaris, OpenIndiana, Debian, and
Arch. Memories aside, this means some of them date back to when I had close to
no idea how a \*nix OS worked, and although I sometimes update the components I
use more often some are just... Bad. But hey, they work! And somehow I end up
procrastinating even when I'm sorta in the mood to takea look at certain
files.  
To be completely honest some started off from what the person who introduced me
to the \*nix world was using at the time.  
  
TL;DR: I should probably feel ashamed and rewrite some of these files (most
notably the ones within zsh folder) but it won't happen anytime soon, if
ever.  



## General info

Global environemnt for multiple machines. Simply run `00-install-env.zsh` as
the user you want to install the env for.  

A config folder will be created in `~/.config/7shi`, and certain scripts can
be configured in there.  

To set the wal theme: `wal --theme green-on-black`  

To set the wal theme from an image: `wal -i /path/to/image`  



## Notes

### Gnome keyring

Just areminder that PAM should be configured to unlock gnome-keyring-daemon
keyrings on login:  

```
/etc/pam.d/login

auth       optional     pam_gnome_keyring.so
session    optional     pam_gnome_keyring.so auto_start
```



### Hyprland

A few notes regarding what's needed to make Hyprland work.  

#### Packages to install

The following packages are required for mmy Hyprland setup:  
```
grim
hyprcursor
hyprgraphics
hypridle
hyprland
hyprland-protocols
hyprland-qt-support
hyprland-qtutils
hyprlang
hyprlock
hyprpicker
hyprsunset
hyprutils
hyprwayland-scanner
mpvpaper
nerdshade
rofi-wayland
slurp
waybar
wayland-protocols
wf-recorder
wf-recorder-gui
wl-clipboard
wlr-randr
xdg-desktop-portal-hyprland
xorg-xwayland
```

On nvidia cards these are also needed:  
```
libva-nvidia-driver
egl-wayland
nvidia-utils
```

#### Issues with Lightdm (connected input devices not working)

Due to a race condition, this has to be added in `/etc/lightdm/Xsession`:  
```
[...]

echo "X session wrapper complete, running session $@"

# Wayland hotfix:
if [[ ${XDG_SESSION_TYPE} == "wayland" ]]; then
  echo "Sleeping for wayland"
  sleep 1
  echo "Woke up"
fi

exec $@
```

#### Prevent lid closure from suspending to ram

This has to be done via systemd editing `/etc/systemd/logind.conf`:  
```
[Login]
HandleLidSwitch=ignore
```

#### Issues with screen sharing

Ideally everything should work with the portal, but the following gist contains
a lot of useful info:
https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580  

#### Have chrome-based browsers run on wayland instead of xwayland

chrome://flags -> Search for `ozone` -> set to `Auto`  

Or manually launch them with
`--enable-features=UseOzonePlatform --ozone-platform=wayland`.  

If they fail to launch (as some electron apps do) it may be necessary to add
`--disable-gpu`.  



### Input methods

Ditched ibus for fcitx5, as it isn't giving any headaches with hyprland.  
```
pacman -S fcitx5-im fcitx5-mozc
```



### UFW

I am aware a user-managed ufw file is a no-no. BUT I'm aware of it and it's
easy to spot if a repo file has been tampered with.  

However, apparently I easily forget ufw commands so...  

List available apps -> `ufw app list`  
Add a new any-to-any rule -> `ufw allow "app"`  
Add a rule for a subnet -> `ufw allow from 192.168.1.0/24 to any app "app"`  
Show status with numbered active rules -> `ufw status numbered`  
Delete an active rule -> `ufw delete <number>`  



### Xorg nvidia config

Configuration to avoid a couple of tearing issues with picom when using a
nvidia card:  

```
Section "Device"
  Identifier "nvidia"
  Driver "nvidia"
  VendorName "NVIDIA Corporation"
  Option "Coolbits" "28"
  Option "RegistryDwords" "EnableBrightnessControl=1"
EndSection

Section "Screen"
  Identifier "nvidia"
  Option "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
  Option "AllowIndirectGLXProtocol" "off"
  Option "TripleBuffer" "on"
EndSection
```

