# Config file reader.
# Takes as parameters:
#   $1 => file to read
#   $2 => config value to read
function 7shi_load_conf()
{
  print "$(grep "^${2}=" "${1}" 2> /dev/null | sed -e "s,^${2}=,,")"
}

