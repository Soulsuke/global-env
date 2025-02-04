#! /usr/bin/env zsh

# Output file path:
OUT="${HOME}/.config/hypr/00-per_host/per_host.conf"

# Partial name:
NAME=".config/hypr/00-per_host/per_host.conf.d/$(hostnamectl hostname).conf"

# Add in the source directive only if the right file is present:
if [[ -f "${HOME}/${NAME}" ]]; then
  print "source = ~/${NAME}" >| "${OUT}"

# Otherwise, create an empty file:
else
  print "" >| "${OUT}"
fi

