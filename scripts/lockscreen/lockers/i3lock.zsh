#! /usr/bin/env zsh

###############################################################################
### Lockscreen alternatives                                                 ###
###############################################################################

# Temporary processed image:
TMP_LOCK="/tmp/screen_locked.png"

# Pixelated screenshot.
function pixelated()
{
  # Take a picture of the screen:
  escrotum ${TMP_LOCK}

  # Pixellate it:
  convert ${TMP_LOCK} -scale 10% -scale 1000% ${TMP_LOCK}

  # Use it as a wallpaper:
  i3lock -t -e -f -n -i ${TMP_LOCK}

  # Cleanup:
  rm ${TMP_LOCK}
}

# Fake BSOD screen from Windows 10.
function fakeBsod10()
{
  # Current resolution:
  local RES=$(
    xdpyinfo 2> /dev/null | grep dimensions | sed -e 's, pixels.*,,' | \
      sed -e "s,.* ,,"
  )

  # Resize the original picture to fit the screen:
  convert ~/.scripts/7shi/lockscreen/resources/fakeBsod10.png -resize ${RES} \
    ${TMP_LOCK}

  # Set it as a wallpaper:
  i3lock -t -e -f -n -p win -i ${TMP_LOCK}

  # Cleanup:
  rm ${TMP_LOCK}
}



###############################################################################
### Utility wrapper                                                         ###
###############################################################################

# Wrapper function, so dunstctl can be called after i3-lock ends yet & can be
# used to run subsequent commands before it happens..
function lock_i3()
{
  # Config reader:
  source ~/.scripts/7shi/lib/load_conf.zsh

  # Use the lockscreen set in the config file:
  SS=$(7shi_load_conf ~/.config/7shi/locker/i3lock modality)

  # Default to plain i3lock if it isn't an allowed command:
  case ${SS} in
    pixelated | \
    fakeBsod10)   ;;
    *) SS="i3lock";;
  esac

  # Start the lockscreen and unpause dunst afterwards:
  ${SS}; dunstctl set-paused false
}



###############################################################################
### Entry point                                                             ###
###############################################################################

# Pause dunst's notifications:
dunstctl set-paused true

# Start the screensaver:
lock_i3 &

# Give it a second to load:
sleep 1

# Then turn off the monitor:
xset dpms force off

