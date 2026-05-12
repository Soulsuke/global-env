-------------------------------------------------------------------------------
--- Defaults                                                                ---
---                                                                         ---
--- Usually overridden by per-host settings, but better safe than sorry.    ---
-------------------------------------------------------------------------------

-- Monitor:
hl.monitor(
  {
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1
  }
)



-- Unscale XWayland to avoid blurryness:
hl.config(
  {
    xwayland = {
      force_zero_scaling = true
    }
  }
)



-------------------------------------------------------------------------------
--- Environment variables                                                   ---
-------------------------------------------------------------------------------

hl.env( "XDG_CURRENT_DESKTOP", "Hyprland" )
hl.env( "XDG_SESSION_DESKTOP", "Hyprland" )
hl.env( "XDG_SESSION_TYPE", "wayland" )
hl.env( "QT_QPA_PLATFORM", "wayland;xcb" )
hl.env( "QT_WAYLAND_DISABLE_WINDOWDECORATION", "1" )



-------------------------------------------------------------------------------
--- Hyprland variables                                                      ---
-------------------------------------------------------------------------------

-- Default terminal:
terminal = "kitty"

-- Hostname:
hostname = io.popen("uname -n"):read("*a"):gsub("%s+", "")



-------------------------------------------------------------------------------
--- Sources                                                                 ---
-------------------------------------------------------------------------------

-- Colors from wal:
dofile( os.getenv( "HOME" ) .. "/.cache/wal/hypr.lua" )

-- Folder containing split configuration files:
split_folder = "hyprland"

-- Now require every file it contains:
local found = io.popen(
  "find '" .. os.getenv( "HOME" ) ..
    "/.config/hypr/" .. split_folder ..
    "' -maxdepth 1 -type f  -iname '*.lua' 2>/dev/null"
)
if found then
  for file in found:lines() do
    require( split_folder .. "." ..  file:match( "([^/]+)%.lua$" ) )
  end
  found:close()
end

-- As a last thing, require the host-specific settings (may not exist):
pcall(
  require,
  split_folder .. ".hosts." .. hostname
)



-------------------------------------------------------------------------------
--- Startup programs                                                        ---
-------------------------------------------------------------------------------

hl.on(
  "hyprland.start",
  function()
    -- common stuff:
    hl.exec_cmd(
      os.getenv( "HOME" ) .. "/.scripts/7shi/startup/00-session-startup.zsh"
    )

    -- hyprland family stuff:
    hl.exec_cmd( "systemctl --user start hyprpolkitagent.service" )
    hl.exec_cmd( "hypridle" )
    hl.exec_cmd( "hyprsunset" )
    hl.exec_cmd( "nerdshade -latitude 44.4 -longitude 8.94 -loop" )
  end
)



-------------------------------------------------------------------------------
--- Shutdown commands                                                       ---
-------------------------------------------------------------------------------

-- Apparently these do not die when exiting, and get started again each time...
-- So let's take care of them on shutdown.
hl.on(
  "hyprland.shutdown",
  function()
    hl.exec_cmd( "killall hypridle" )
    hl.exec_cmd( "killall nerdshade" )
  end
)

