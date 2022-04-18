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

# Before linking any scripts, check if wal is present:
local _WAL_PRESENT_=$+commands[wal]

# System-wide config, only if run as root:
if [[ 0 == ${UID} ]]; then
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
for i in *; do
  mkdir -p "${HOME}/.config"
  env_link ${i} "${HOME}/.config/${i}"
done

# Dunst:
rm -fr "${HOME}/.config/dunst" &> /dev/null
mkdir -p "${HOME}/.config/dunst" &> /dev/null
ln -s "${HOME}/.cache/wal/dunstrc" "${HOME}/.config/dunst/dunstrc"

# Global scripts:
cd ${_GLOBAL_ENV_PATH_}
mkdir -p "${HOME}/.scripts"
env_link scripts "${HOME}/.scripts/7shi"

# Session startup config:
cd ${_GLOBAL_ENV_PATH_}/session_startup
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
if (( ${_WAL_PRESENT_} )); then
  wal --theme green-on-black
fi

