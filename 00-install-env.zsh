#! /usr/bin/env zsh

# Function to link the given file in ${HOME}, checking if the file
# already exists and, in case, backing it up.
# Usage: env_link origin destination
# NOTE: PWD is appented to origin's path.
function env_link()
{
  if [[ -L "${2}" ]]; then
    rm -fr "${2}" > /dev/null

  elif [[ -e "${2}" ]]; then
    local CHO=""
    typeset -l CHO
    while [[ ! "${CHO}" == "y" ]] && [[ ! "${CHO}" == "n" ]]; do
      noglob read CHO?"Backup ${2} in ${2}.old? [y/n] "
    done
    if [[ ${CHO} == "y" ]]; then
      mv "${2}" "${2}.old"
    else
      rm -fr "${2}"
    fi
  fi

  mkdir -p "$(dirname ${2})"
  ln -s "${PWD}/${1}" "${2}"
}

# Global env's directory:
local _GLOBAL_ENV_PATH_=${0:A:h}

# Steam deck check:
local DECK=1
[[ -z "$(lsb_release -a | grep SteamOS)" ]] && DECK=0

# Init/update git submodules, but only when this isn't run as root:
if [[ 0 != ${UID} ]]; then
  cd ${_GLOBAL_ENV_PATH_}
  git submodule update --init --recursive
  git submodule update --remote --merge
fi

# System-wide config, only if run as root (skip on Steam Deck):
if [[ 0 == ${UID} ]] && [[ 0 == ${DECK} ]]; then
  cd ${_GLOBAL_ENV_PATH_}/root

  ### X11
  #############################################################################
  mkdir -p /etc/X11/xorg.conf.d

   # Common X11 settings:
   for f in X11/*.conf ; do
     env_link "${f}" "/etc/X11/xorg.conf.d/$(basename ${f})"
   done

  # Per host X11 settings:
  if [[ -d "X11/${HOST}" ]]; then
    for f in "X11/${HOST}/"* ; do
      env_link "${f}" "/etc/X11/xorg.conf.d/$(basename ${f})"
    done
  fi
fi

# Vim:
cd ${_GLOBAL_ENV_PATH_}/vim
for i in *; do
   env_link ${i} ${HOME}/.${i}
done
if [[ ! -e "${HOME}/.vimswap" ]]; then
  mkdir -p "${HOME}/.vimswap"
fi

# zsh:
cd ${_GLOBAL_ENV_PATH_}/zsh
env_link zshrc "${HOME}/.zshrc"
source "${HOME}/.zshrc"

# Config:
cd ${_GLOBAL_ENV_PATH_}/config
mkdir -p "${HOME}/.config"
for i in *; do
  case $i in
    # Cherrytree needs to have its config copied:
    cherrytree)
      mkdir -p "${HOME}/.config/cherrytree"
      rm -fr "${HOME}/.config/cherrytree/config.cfg*" &> /dev/null
      cp cherrytree/config.cfg "${HOME}/.config/cherrytree/"
      env_link cherrytree/styles "${HOME}/.config/cherrytree/styles"
    ;;

    # Special care for dunst:
    dunst)
      mkdir -p "${HOME}/.config/dunst"
      if [[ -L "${HOME}/.config/dunst/dunstrc" ]]; then
        rm "${HOME}/.config/dunst/dunstrc"
      elif [[ -e "${HOME}/.config/dunst/dunstrc" ]]; then
        mv "${HOME}/.config/dunst/dunstrc" "${HOME}/.config/dunst/dunstrc.old"
      fi
      ln -s "${HOME}/.cache/wal/dunstrc" "${HOME}/.config/dunst/dunstrc"
      cd dunst
      for ii in *; do
        env_link ${ii} "${HOME}/.config/dunst/${ii}"
      done
      cd ..
    ;;

    # This one is a little bit tricky: always copy it over, but attempt to set
    # a grossly calculated DPI value:
    Xresources)
      rm "${HOME}/.${i}" &> /dev/null
      cp ${i} "${HOME}/.${i}"

      # Keep 96 DPI on deck:
      [[ 1 == ${DECK} ]] && continue

      WIDTH=$(
        xdpyinfo 2> /dev/null | grep dimensions | sed -e 's,x.*,,' | \
          awk '{print $2}'
      )
      if [[ ! -z ${WIDTH} ]]; then
        GROSS_DPI=$((WIDTH * 96 / 1920))
        sed -i "s,dpi: .*,dpi: ${GROSS_DPI}," "${HOME}/.${i}"
      fi
    ;;

    # These should be linked in HOME and not in ~/.config, but do not need any
    # ad-hoc care themselves:
    inputrc)
      env_link ${i} "${HOME}/.${i}"
    ;;

    # Everything else can be safely linked in ~/.config:
    *)
      env_link ${i} "${HOME}/.config/${i}"
    ;;
  esac
done

# Global scripts:
cd ${_GLOBAL_ENV_PATH_}
mkdir -p "${HOME}/.scripts"
env_link scripts "${HOME}/.scripts/7shi"

# Session startup config:
cd ${_GLOBAL_ENV_PATH_}/session_startup
env_link profile "${HOME}/.profile"
env_link xinitrc "${HOME}/.xinitrc"
env_link xprofile "${HOME}/.xprofile"
mkdir -p "${HOME}/.local/share/applications"
env_link common_startup_applications.desktop \
  "${HOME}/.local/share/applications/common_startup_applications.desktop"

# Copy template config over if needed:
cd ${_GLOBAL_ENV_PATH_}/templates/config
for i in $(find . -type f); do
  F="${HOME}/.config/7shi/$(dirname ${i})"
  mkdir -p "${F}"
  if [[ ! -f "${F}/${i}" ]]; then
    cp ${i} "${F}/$(basename ${i})"
  fi
done

# If wal is present, run it once to ensure everything is there:
[[ $(command -v wal) ]] && wal --theme green-on-black

# Restart dunst:
killall dunst &> /dev/null

