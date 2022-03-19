class NordVPN

  #############################################################################
  ### Attributes                                                            ###
  #############################################################################

  attr_reader :icon
  attr_reader :details
  attr_reader :status
  attr_reader :update_in_progress
  attr_reader :error_color
  attr_reader :connecting_color
  attr_reader :connected_color
  attr_reader :changing_status



  #############################################################################
  ### Public methods                                                        ###
  #############################################################################

  # Constructor.
  def initialize( opts = {} )
    @details = false
    @status = Hash.new
    @update_in_progress = false
    @changing_status = false
    @label = opts[ :label ] || ""
    @error_color = opts[ :error_color ] || "#F00"
    @connecting_color = opts[ :connecting_color ] || "#FFB52A"
    @connected_color = opts[ :connected_color ] || "#00F"
  end



  # Returns true or false, depending if nordvpn client is available.
  def ok
    # Return value container:
    ret = true

    # check if nordvpn is available:
    `which nordvpn &> /dev/null`
    if 0 != $? then
      ret = false

      # Message for the user:
      puts "%{F#{@error_color}}#{@label}%{F-}"
      STDOUT.flush
    end

    # Finally, return ret:
    return ret
  end



  # Returns NordVPN's status.
  def update
    return if @update_in_progress

    # Lock this:
    @update_in_progress = true

    # Blank the previous status:
    @status = Hash.new

    # Parse the raw data:
    `nordvpn status`.split( "\n" ).each do |line|
      key, val = line.split ": "
      @status[ key.downcase.split( " " ).last.to_sym ] = val
    end

    # Update the shown prompt:
    show

    # Unlock this:
    @update_in_progress = false
  end



  # Composes a decent prompt
  def show
    # Support variable:
    connected = @status[ :status ] == "Connected"

    # Icon to show, color depending on the connection status:
    icon = @label
    if connected then
      icon = "%{F#{@connected_color}}#{icon}%{F-}"
    end

    # Simple status:
    if !@details or !connected then
      puts icon
    # Detailed status:
    else
      puts "#{icon} #{@status[ :server ]} (#{@status[ :ip ]} " +
        "#{@status[ :country ]}, #{@status[ :city ]})"
    end

    STDOUT.flush
  end



  # Toggles details.
  def toggle_details
    @details = !@details
    show
  end



  # Toggles connection.
  def toggle_connection
    # Only one status change:
    return if @changing_status

    # Lock this:
    @changing_status = true

    # Temporary message for the user:
    puts "%{F#{@connecting_color}}#{@label}%{F-}"
    STDOUT.flush

    # Connect or disconnect depending on the current status:
    if @status[ :status ] == "Connected" then
      `nordvpn d`
    else
      `nordvpn c`
    end

    # Also update the show info:
    update

    # Finally unlock this:
    @changing_status = false
  end

end



###############################################################################
### Standalone logic                                                        ###
###############################################################################

if __FILE__ == $0 then
  n = NordVPN.new label: ARGV[ 0 ],
    error_color: ARGV[ 1 ],
    connecting_color: ARGV[ 2 ],
    connected_color: ARGV[ 3 ]

  return unless n.ok

  # Update info on USR1 signal:
  Signal.trap "USR1" do
    # Update the info:
    n.toggle_connection
  end

  # Change output format on USR2 signal:
  Signal.trap "USR2" do
    n.toggle_details
  end

  # Connect/disconnect on CONT signal:
  Signal.trap "CONT" do
    n.update
  end

  # Update shown info every 5 seconds:
  loop do
    n.update
    sleep 5
  end

end

