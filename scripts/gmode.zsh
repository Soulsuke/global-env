#! /usr/bin/env zsh

###############################################################################
### Functions                                                               ###
###############################################################################

# Gets gmode's status.
function g_status
{
  echo "\_SB.AMWW.WMAX 0 0x25 {0x02, 0x00, 0x00, 0x00}" > /proc/acpi/call
  grep "0x0" /proc/acpi/call &> /dev/null
  echo $?
}

# Enables gmode.
function g_enable
{
  echo "\_SB.AMWW.WMAX 0 0x14 {0xb, 0x0, 0x0, 0x00}" > /proc/acpi/call
  echo "\_SB.AMWW.WMAX 0 0x25 {1, 0x01, 0x00, 0x00}" > /proc/acpi/call
  echo "\_SB.AMWW.WMAX 0 0x15 {1, 0xab, 0x00, 0x00}" > /proc/acpi/call
}

# Disables gmode.
function g_disable
{
  echo "\_SB.AMWW.WMAX 0 0x14 {0xb, 0x0, 0x0, 0x00}" > /proc/acpi/call
  echo "\_SB.AMWW.WMAX 0 0x25 {1, 0x00, 0x00, 0x00}" > /proc/acpi/call
  echo "\_SB.AMWW.WMAX 0 0x15 {1, 0xa0, 0x00, 0x00}" > /proc/acpi/call
}

# Toggles gmode.
function g_toggle
{
  if [[ 0 == $(g_status) ]]; then
    g_enable
  else
    g_disable
  fi
}



###############################################################################
### Entry point                                                             ###
###############################################################################

# Non-root users should try to escalate:
if [[ ${UID} != 0 ]]; then
  pkexec "${0}" ${@}
  exit ${?}
fi



# No parameters means toggle:
if [[ ${#} == 0 ]]; then
  g_toggle

# Otherwise check what's been given:
else
  case ${1} in
    --on|on)
      g_enable
    ;;

    --off|off)
      g_disable
    ;;

    --toggle|toggle)
      g_toggle
    ;;

    --status|status)
      g_status
    ;;

    *)
      echo "Command not recognized"
      exit 1
    ;;
  esac
fi

