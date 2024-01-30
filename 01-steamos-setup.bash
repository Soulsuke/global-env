#! /usr/bin/env bash

# Root check:
if [[ ! "${USER}" == "root" ]]; then
  echo "You need root privileges to run this."
  exit 1
fi



# Packages to install via pacman:
TO_INSTALL=(
  git
  glibc
  openssh
  rsync
  vim
  vivaldi
  vivaldi-ffmpeg-codecs
  zsh
)



# Locales to enable:
LOCALES=(
  "en_GB.UTF-8"
  "it_IT.UTF-8"
  "ja_JP.UTF-8"
)



# Full line separator (with fallback):
SEP=""
if [[ $(command -v tput) ]]; then
  I=0
  TCOLS=$(tput cols)
  while [[ ${I} -lt ${TCOLS} ]]; do
    SEP+="="
    I=$((I + 1))
  done
else
  SEP="======================================================================="
fi



# Control variable, so we0ll eval only on SteamOS:
lsb_release -a | grep SteamOS &> /dev/null
NOT_STEAMOS=$?



# Utility function: prints a nice colored line and executes a command.
# Parameters:
#  - prompt to print after the colored line
#  - command string to eval
function execho()
{
  # Bold: \e[1m
  # Black background: \e[49m
  # Red foreground: \e[31m
  P="\e[1m\e[49m\e[31m"

  # Full line separator:
  echo -e "${P}${SEP}"
  echo -e "${P}=====>\e[0m ${1}"

  # Only eval on SteamOS, otherwise just echo: 
  if [[ 0 == ${NOT_STEAMOS} ]]; then
    eval "${2}"
  else
    echo "${2}"
  fi
}



execho "Removing readonly flag..." "steamos-readonly disable"

execho "Setting up keyring..." "pacman-key --init"

execho "Populating keyring..." "pacman-key --populate archlinux"

execho "Updating keyring..." "pacman -S --noconfirm --overwrite \* archlinux-keyring"

execho "Installing packages..." "pacman -S --noconfirm --overwrite \* ${TO_INSTALL[*]}"

execho "Setting user shell to zsh..." "chsh -s /bin/zsh deck"

for l in ${LOCALES[@]}; do
  execho "Enabling locale '${l}'..." \
         "sed -i \"s,^#${l},${l},\" /etc/locale.gen"
done

execho "Generating locales..." "locale-gen"

execho "Setting back readonly flag..." "steamos-readonly enable"

