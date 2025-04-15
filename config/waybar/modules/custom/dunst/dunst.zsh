#! /usr/bin/env zsh

# If it's enabled:
if dunstctl is-paused | grep -q "false" ; then
  print '{ "text": "", "class": "enabled" }'

# If it's disabled, also show the number of pending notifications:
else
  local PENDING=$(dunstctl count waiting)
  if [[ 0 == ${PENDING} ]]; then
    PENDING=""
  else
    PENDING=" (${PENDING})"
  fi

  print "{ \"text\": \"${PENDING}\", \"class\": \"disabled\" }"
fi

