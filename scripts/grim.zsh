#! /usr/bin/env zsh

grim $@ "$(xdg-user-dir PICTURES)/grim_$(date "+%Y-%m-%d_%H-%M-%S").png"

