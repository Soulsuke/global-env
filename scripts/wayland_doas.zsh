#! /usr/bin/env zsh

# Sudo command to execute:
local SCMD="sudo"
[[ $(command -v doas) ]] && SCMD="doas"

# Allow root to use the user's X session:
print "Allowing root to access the X server"
xhost +SI:localuser:root
print ""
print ""
print ""

# Run the given command:
print "Running command: ${SCMD} ${@}"
${SCMD} ${@}
print ""
print ""
print ""

# And remove the root access:
print "Restoring X server permissions"
xhost -SI:localuser:root
print ""
print ""
print ""

# To be extra sure, print the current xhost settings:
print "Current xhost status"
xhost

