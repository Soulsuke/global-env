-------------------------------------------------------------------------------
--- Bindings                                                                ---
--- https://wiki.hypr.land/Configuring/Basics/Binds/                        ---
-------------------------------------------------------------------------------



-- Modifier key:
mod = "SUPER"



--- Keybindings: windows and workspaces
-------------------------------------------------------------------------------

-- Lazy way out:
for i = 0, 9 do
  wsp = i
  if wsp == 0 then
    wsp = 10
  end

  -- Switch to workplace:
  hl.bind(
    mod .. " + " .. i,
    hl.dsp.focus( { workspace = wsp  } )
  )

  -- Move window to workplace:
  hl.bind(
    mod .. " + SHIFT + " .. i,
    hl.dsp.window.move( { workspace = wsp, follow = false } )
  )
end

-- Another lazy way out:
for _, dir in ipairs( { "left", "right", "up", "down" } ) do
  -- Change focused window:
  hl.bind(
    mod .. " + " .. dir,
    hl.dsp.focus( { direction = dir } )
  )

  -- Move focused window:
  hl.bind(
    mod .. " + SHIFT + " .. dir,
    hl.dsp.window.move( { direction = dir } )
  )
end

-- Close focused window:
hl.bind( mod .. " + SHIFT + Q", hl.dsp.window.close() )

-- Fullscreen for focused window:
hl.bind( mod .. " + F", hl.dsp.window.fullscreen( { mode = 0 } ) )

-- Maximize focused window:
hl.bind( mod .. " + F", hl.dsp.window.fullscreen( { mode = 1 } ) )

-- Toggle tiling/floating for focused window:
hl.bind(
  mod .. " + SHIFT + Space",
  hl.dsp.window.float( { action = "toggle" } )
)

-- Move window with left click:
hl.bind( mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true } )

-- Resize window with right click:
hl.bind( mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true } )

--- Resize window with arrows:
hl.bind(
  mod .. " + SHIFT + ALT + right",
  hl.dsp.window.resize( { x = 10,  y = 0, relative = true } ),
  { repeating = true }
)
hl.bind(
  mod .. " + SHIFT + ALT + left",
  hl.dsp.window.resize( { x = -10, y = 0, relative = true } ),
  { repeating = true }
)
hl.bind(
  mod .. " + SHIFT + ALT + up",
  hl.dsp.window.resize( { x = 0,  y = -10, relative = true } ),
  { repeating = true }
)
hl.bind(
  mod .. " + SHIFT + ALT + down",
  hl.dsp.window.resize( { x = 0,  y = 10, relative = true } ),
  { repeating = true }
)

-- Switch layouts:
hl.bind(
  mod .. " + L",
  hl.dsp.exec_cmd( 'hyprctl keyword general:layout "dwindle"' )
)
hl.bind(
  mod .. " + SHIFT + L",
  hl.dsp.exec_cmd( 'hyprctl keyword general:layout "master"' )
)



--- Keybindings: master layout
-------------------------------------------------------------------------------

-- Master window selection:
hl.bind( mod .. " + tab", hl.dsp.layout( "swapwithmaster" ) )
hl.bind( mod .. " + mouse:274", hl.dsp.layout( "swapwithmaster") )

-- Decrease/increase master window ratio with scrollwheel:
hl.bind( mod .. " + mouse_down", hl.dsp.layout( "mfact -0.2" ) )
hl.bind( mod .. " + mouse_up",   hl.dsp.layout( "mfact +0.2" ) )

-- Change master layout orientation:
hl.bind( mod .. " + ALT + left",  hl.dsp.layout( "orientationleft") )
hl.bind( mod .. " + ALT + right", hl.dsp.layout( "orientationright") )
hl.bind( mod .. " + ALT + up",    hl.dsp.layout( "orientationtop") )
hl.bind( mod .. " + ALT + down",  hl.dsp.layout( "orientationbottom") )
hl.bind( mod .. " + ALT + Space", hl.dsp.layout( "orientationcenter") )

-- Cycle master layout orientation active window:
hl.bind( mod .. " + CTRL + left",  hl.dsp.layout( "rollprev" ) )
hl.bind( mod .. " + CTRL + right", hl.dsp.layout( "rollnext" ) )



--- Keybindings: session behaviour
-------------------------------------------------------------------------------

-- Lid close means lockscreen, not hybernation:
hl.bind(
  "switch:on:Lid Switch",
  hl.dsp.exec_cmd( "loginctl lock-session" ),
  { locked = true }
)
hl.bind(
  "switch:off:Lid Switch",
  function()
    hl.dispatch( hl.dsp.dpms( "on" ) )
  end,
  { locked = true }
)

-- Lock screen:
hl.bind( mod .. " + Return", hl.dsp.exec_cmd( "loginctl lock-session" ) )



--- Keybindings: media keys
-------------------------------------------------------------------------------

-- Avoid needless repetitions:
local flags = { locked = true, repeating = true }


-- Touchpad toggle:
hl.bind(
  "XF86TouchpadToggle",
  hl.dsp.exec_cmd( "~/.scripts/7shi/touchpad_toggle.zsh" ), flags
)
hl.bind(
  mod .. " + T",
  hl.dsp.exec_cmd( "~/.scripts/7shi/touchpad_toggle.zsh" )
)

-- Sink volume down:
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd( "wpctl set-volume @DEFAULT_SINK@ 5%-" ),
  flags
)

-- Sink volume up:
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd( "wpctl set-volume @DEFAULT_SINK@ 5%+" ),
  flags
)

-- Sink mute:
local mute_keys = {
  "XF86AudioMute",
  mod .. " + XF86AudioMicMute",
  "ALT + XF86AudioLowerVolume"
}
for _, k in ipairs( mute_keys ) do
  hl.bind(
    k,
    hl.dsp.exec_cmd( "~/.scripts/7shi/wpctl_set_mute_all.zsh Sinks toggle" ),
    { locked = true }
  )
end

-- Source volume down:
hl.bind(
  mod .. " + XF86AudioLowerVolume",
  hl.dsp.exec_cmd( "wpctl set-volume @DEFAULT_SOURCE@ 5%-" ),
  flags
)

-- Source volume up:
hl.bind(
  mod .. " + XF86AudioRaiseVolume",
  hl.dsp.exec_cmd( "wpctl set-volume @DEFAULT_SOURCE@ 5%+" ),
  flags
)

-- Source mute:
local mic_mute_keys = {
  "XF86AudioMicMute",
  mod .. " + XF86AudioMute",
  mod .. " + ALT + XF86AudioLowerVolume"
}
for _, k in ipairs( mic_mute_keys ) do
  hl.bind(
    k,
    hl.dsp.exec_cmd( "~/.scripts/7shi/wpctl_set_mute_all.zsh Sources toggle" ),
    { locked = true }
  )
end

-- Brightness down:
hl.bind( "XF86MonBrightnessDown", hl.dsp.exec_cmd( "light -U 5" ), flags )
hl.bind( mod .. " + O", hl.dsp.exec_cmd( "light -U 5" ) )

-- Brightness up:
hl.bind( "XF86MonBrightnessUp", hl.dsp.exec_cmd( "light -A 5" ), flags )
hl.bind( mod .. " + P", hl.dsp.exec_cmd( "light -A 5" ) )

-- Media player play:
hl.bind(
  "XF86AudioPlay",
  hl.dsp.exec_cmd( "playerctl play" ),
  { locked = true }
)

-- Media player pause:
hl.bind(
  "XF86AudioPause",
  hl.dsp.exec_cmd( "playerctl pause" ),
  { locked = true }
)

-- Media player next:
hl.bind(
  "XF86AudioNext",
  hl.dsp.exec_cmd( "playerctl next" ),
  flags
)

-- Media player previous:
hl.bind(
  "XF86AudioPrev",
  hl.dsp.exec_cmd( "playerctl previous" ),
  flags
)



--- Keybindings: rofi
-------------------------------------------------------------------------------

-- Menu using .desktop files:
hl.bind( mod .. " + D", hl.dsp.exec_cmd( "rofi -show drun" ) )

-- Menu using executables within path:
hl.bind( mod .. " + SHIFT + D", hl.dsp.exec_cmd( "rofi -show run" ) )

-- Session manager (rofi-script menu):
hl.bind(
  mod .. " + SHIFT + E",
  hl.dsp.exec_cmd(
    "rofi -show sessionmgr -modi " ..
      "'sessionmgr:~/.config/rofi/scripts/sessionmgr.zsh'"
  )
)



--- Keybindings: other
-------------------------------------------------------------------------------

-- Take a screenshot of the whole desktop:
hl.bind( "Print", hl.dsp.exec_cmd( "~/.scripts/7shi/grim.zsh" ) )

-- Take a screenshot of an area/window:
hl.bind(
  "SHIFT + Print",
  hl.dsp.exec_cmd( "slurp | ~/.scripts/7shi/grim.zsh -g -" )
)

-- Start the terminal:
hl.bind( mod .. " + Q", hl.dsp.exec_cmd( terminal ) )

-- Start hyprpicker (copy into clipboard):
hl.bind( mod .. " + C", hl.dsp.exec_cmd( "hyprpicker -a" ) )

