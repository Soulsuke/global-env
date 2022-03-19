# Turns iostat output into a human-readable string with the right measuring
# unit.
def to_human( value )
  value = value.to_f
  if value >= 1024 then
    value = "#{(value / 1024).round 2} MiB"
  else
    value = "#{value.round 2} KiB"
  end
end



# Options from parameters:
type = ARGV[ 0 ]
device = ARGV[ 1 ]
lbl_read = ARGV[ 2 ] || ""
lbl_write = ARGV[ 3 ] || ""



# Keep going:
while true do
  # Get raw data from iostat:
  io = `iostat -k -y -d 1 1 #{device}`.split "\n"

  # Remove useless entries:
  io.delete ""

  # Turn each line into a hash:
  io = io.map { |e| e.split " " }

  # Find the data relative to current IO speed:
  read = io[ 2 ][ io[ 1 ].index "kB_read/s" ]
  wrtn = io[ 2 ][ io[ 1 ].index "kB_wrtn/s" ]

  # Show the composed prompt:
  puts "#{to_human read} #{lbl_read} #{lbl_write} #{to_human wrtn}"

  # Let's be sure to do this:
  STDOUT.flush
end

