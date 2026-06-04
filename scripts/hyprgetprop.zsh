#! /usr/bin/env zsh

# Load colors:
autoload -U colors && colors



# Default to no_screen_share prop if none is given:
if [[ -z ${1} ]]; then
  PROP="no_screen_share"
else
  PROP="${1}"
fi

# Intro message:
print "${fg[blue]}Querying for prop:${fg[default]} '${PROP}'\n"

# Fetch the info for each window and print it out:
hyprctl clients -j | \
  jq -r '.[] | "\(.address) \(.class)"' | \
  while read -r ADDRESS CLASS
do
  print "${CLASS} => " \
          ${fg[red]}$(hyprctl getprop address:${ADDRESS} ${PROP}) \
          "${fg[default]}"
done

