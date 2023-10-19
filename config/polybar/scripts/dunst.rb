class Dunst

  #############################################################################
  ### Attributes                                                            ###
  #############################################################################

  attr_reader :icon
  attr_reader :on_color
  attr_reader :paused_color
  attr_reader :off_color



  #############################################################################
  ### Public methods                                                        ###
  #############################################################################

  # Constructor.
  def initialize( icon:, on_color:, paused_color:, off_color: )
    @icon = icon
    @off_color = off_color
    @paused_color = paused_color
    @on_color = on_color
  end



  # Composes a decent output.
  def show
    out = `dunstctl is-paused`.chomp

    if !$?.success? then
      puts "%{F#{@off_color}}#{@icon}%{F-}"
    elsif out == "true" then
      puts "%{F#{@paused_color}}#{@icon}%{F-}"
    else
      puts "%{F#{@on_color}}#{@icon}%{F-}"
    end

    STDOUT.flush
  end



  # Toggles the notifications.
  def toggle_notifications
    `dunstctl set-paused toggle`
    show
  end

end



###############################################################################
### Standalone logic                                                        ###
###############################################################################

if __FILE__ == $0 then
  d = Dunst.new \
    icon: ARGV[ 0 ],
    on_color: ARGV[ 1 ],
    paused_color: ARGV[ 2 ],
    off_color: ARGV[ 3 ]

  # Update info on USR1 signal:
  Signal.trap "USR1" do
    d.toggle_notifications
  end

  # Update shown info every 5 seconds:
  loop do
    d.show
    sleep 5
  end

end

