#! /usr/bin/env zsh

# Since I'm quite lazy and I don't want to add too many custom rules directly
# into dunstrc, I'll have this script handle the eventual custom operations.
# Worst comes to pass, the overhead to process this should be negligible.

# Available dunst variables:
# DUNST_APP_NAME
# DUNST_SUMMARY
# DUNST_BODY
# DUNST_ICON_PATH
# DUNST_URGENCY
# DUNST_ID
# DUNST_PROGRESS
# DUNST_CATEGORY
# DUNST_STACK_TAG
# DUNST_URLS
# DUNST_TIMEOUT
# DUNST_TIMESTAMP
# DUNST_DESKTOP_ENTRY
# DUNST_STACK_TAG



###############################################################################
### Utility functions                                                       ###
###############################################################################

# Logs everything.
function log_everything()
{
  OUT="${HOME}/dunst_notifications"
  touch ${OUT}
  echo "============================================================" >> ${OUT}
  echo "DUNST_APP_NAME: __${DUNST_APP_NAME}__" >> ${OUT}
  echo "DUNST_SUMMARY: __${DUNST_SUMMARY}__" >> ${OUT}
  echo "DUNST_BODY: __${DUNST_BODY}__" >> ${OUT}
  echo "DUNST_ICON_PATH: __${DUNST_ICON_PATH}__" >> ${OUT}
  echo "DUNST_URGENCY: __${DUNST_URGENCY}__" >> ${OUT}
  echo "DUNST_ID: __${DUNST_ID}__" >> ${OUT}
  echo "DUNST_PROGRESS: __${DUNST_PROGRESS}__" >> ${OUT}
  echo "DUNST_CATEGORY: __${DUNST_CATEGORY}__" >> ${OUT}
  echo "DUNST_STACK_TAG: __${DUNST_STACK_TAG}__" >> ${OUT}
  echo "DUNST_URLS: __${DUNST_URLS}__" >> ${OUT}
  echo "DUNST_TIMEOUT: __${DUNST_TIMEOUT}__" >> ${OUT}
  echo "DUNST_TIMESTAMP: __${DUNST_TIMESTAMP}__" >> ${OUT}
  echo "DUNST_DESKTOP_ENTRY: __${DUNST_DESKTOP_ENTRY}__" >> ${OUT}
  echo "DUNST_STACK_TAG: __${DUNST_STACK_TAG}__" >> ${OUT}
  echo "============================================================" >> ${OUT}
}

# Sets window as urgent.
function set_window_urgent()
{
  xdotool set_window --urgency 1 \
    "$(xdotool search --name "${DUNST_APP_NAME}" | sort -n | head -n1)" \
    &> /dev/null
}



###############################################################################
### Actual rules                                                            ###
###############################################################################

# Sadly, the day is here:
if [[ "${DUNST_BODY}" =~ "support.dotvocal.com" ]]; then
  set_window_urgent
  mpv /usr/share/sounds/freedesktop/stereo/service-login.oga &> /dev/null
fi

