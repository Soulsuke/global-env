require "json"
require "net/http"



class IpInfo

  #############################################################################
  ### Public attributes                                                     ###
  #############################################################################
  attr_reader :error_color
  attr_reader :full_info
  attr_reader :info
  attr_reader :connected
  attr_reader :ip_data
  attr_reader :label
  attr_reader :update_in_progress
  attr_reader :uri
  attr_reader :warning_color



  #############################################################################
  ### Public methods                                                        ###
  #############################################################################

  def initialize( opts = {} )
    @error_color = opts[ :error_color ] || "#F00"
    @full_info = opts[ :full_info ] == true
    @info = opts[ :info ] == true
    @ip_data = nil
    @label = opts[ :label ] || ""
    @update_in_progress = false
    @uri = URI "https://ifconfig.co/json"
    @warning_color = opts[ :warning_color ] || "#FFB52A"
    @connected = false

    
  end

  # Updates the IP info and shows it:
  def update( forced = false )
    # Do nothing if there's an update in progress:
    return if @update_in_progress

    # Prevent concurrent update requests:
    @update_in_progress = true

    # Temporary message for the user if he has asked for a forced refresh:
    if forced then
      puts "%{F#{@warning_color}}#{@label}%{F-}"
      STDOUT.flush
    end

    # Ping Google to check if the net is reachable:
    `ping google.com -c 1 -W 1 &> /dev/null`

    # Update the connection status:
    @connected = $?.success?

    # If we are not connected (or forcing a refresh), clean up the stored info:
    if !@connected or forced then
      @ip_data = nil
    end

    # Only retrieve new data if we have none and we are connected:
    if @ip_data.nil? and @connected then
      # Let's be extra sure:
      begin
        # Perform the request:
        @ip_data = JSON.parse( Net::HTTP.get @uri )
          .slice( "ip", "country", "city" )
          .map { |k,v| [k.to_sym, v] }
          .to_h

      # If something goes wrong:
      rescue => e
         @ip_data = nil
      end
    end

    # Update the shown data:
    show

    # Allow new update requests:
    @update_in_progress = false
  end

  # Prints out the current IP info:
  def show
    # Just a red dot if we are not connected:
    if !@connected then
      puts "%{F#{@error_color}}#{@label}%{F-}"

    # IP info:
    else
      # If no info has to be shown, just put in a green label if we are
      # connected:
      unless @info then
        puts "#{@label}"

      # Else, add in the right info:
      else
        # Always put in the label:
        to_print = "#{@label}"

        # If we have no data available, show a warning:
        if @ip_data.nil? then
          to_print += "%{F#{@warning_color}} NO INFO%{F-}"

        else
          # Always add the current ip:
          to_print += " #{@ip_data[ :ip ]}"

          if @full_info and @ip_data[ :country ] then
             to_print += " (#{@ip_data[ :country ]}"
             to_print += ", #{@ip_data[ :city ]}" if @ip_data[ :city ]
             to_print += ")"
          end
        end

        puts to_print
      end
    end

    # Always flush at the end:
    STDOUT.flush 
  end

  # Show/hide full info:
  def toggle_full_info
    @full_info = !@full_info
    show
  end

  # Show/hide connection info:
  def toggle_ip_info
    @info = !@info
    show
  end

end



# If this has been launched as a standalone:
if $0 == __FILE__ then

  # Instance the class:
  ip_info = IpInfo.new label: ARGV[ 0 ],
    error_color: ARGV[ 1 ],
    warning_color: ARGV[ 2 ],
    full_info: true,
    info: false

  # Update info on USR1 signal:
  Signal.trap "USR1" do
    # Update the info:
    ip_info.update true
  end

  # Change output format on USR2 signal:
  Signal.trap "USR2" do
    ip_info.toggle_full_info
  end

  Signal.trap "CONT" do
    ip_info.toggle_ip_info
  end

  # Check connectivity every 3 seconds:
  ip_info.update true
  loop do
    sleep 3
    ip_info.update
  end

end

