-- Set the monitor, resulotion and scaling (can be checked via wlr-randr):
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor(
  {
    output = "eDP-2",
    mode = "2560x1600@240",
    position = "0x0",
    scale = 1.25
  }
)

-- Mouse cursor size:
hl.env( "XCURSOR_SIZE", "24" )
hl.env( "HYPRCURSOR_SIZE", "24" )

