#! /usr/bin/env zsh

CMD=${1}

wpctl status | grep Microphone | \
  awk "/│/ {gsub(\"[*.]\",\"\"); system(\"wpctl set-mute \" \$2 \" ${CMD}\")}"

