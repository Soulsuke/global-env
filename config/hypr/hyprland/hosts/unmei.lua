-- Set the monitor, resulotion and scaling (can be checked via wlr-randr):
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor(
  {
    output = "eDP-1",
    mode = "1920x1080@120",
    position = "0x0",
    scale = 1
  }
)

-- Mouse cursor size:
hl.env( "XCURSOR_SIZE", "24" )
hl.env( "HYPRCURSOR_SIZE", "24" )

-- Fixes for nvidia cards:
-- Check: https://wiki.hyprland.org/Nvidia/
hl.env( "LIBVA_DRIVER_NAME", "nvidia" )
hl.env( "GBM_BACKEND", "nvidia-drm" )
hl.env( "__GLX_VENDOR_LIBRARY_NAME", "nvidia" )
hl.env( "NVD_BACKEND", "direct" )

