#! /usr/bin/env zsh

COUNT=$(dunstctl count waiting)
ENABLED=
DISABLED=

if [ ${COUNT} != 0 ]; then
  DISABLED=" ${COUNT}"
fi

if dunstctl is-paused | grep -q "false" ; then
  print ${ENABLED}
else
  print ${DISABLED}
fi

