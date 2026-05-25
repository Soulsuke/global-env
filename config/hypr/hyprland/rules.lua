-------------------------------------------------------------------------------
--- Rules for windows and workspaces                                        ---
---                                                                         ---
--- https://wiki.hypr.land/Configuring/Basics/Window-Rules/                 ---
--- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/              ---
-------------------------------------------------------------------------------

--- General layout
-------------------------------------------------------------------------------

-- Focused window gets no rounding:
hl.window_rule(
  {
    name = "no-rounding-focused",
    rounding = 0,
    match = {
      focus = 1
    }
  }
)

-- No rouding and borders on fullscreen and maximized windows:
hl.window_rule(
  {
    name = "no-rounding-maximized-fullscreen",
    rounding = 0,
    border_size = 0,
    match = {
      float = false,
      workspace = "f[1]"
    }
  }
)

-- No rounding and borders if there's only one visible window:
hl.window_rule(
  {
    name = "no-rounding-only-window",
    border_size = 0,
    rounding = 0,
    match = {
      float = false,
      workspace = "w[tv1]"
    }
  }
)

-- No gaps if there's only one visible window or if one is maximized:
hl.workspace_rule(
  {
    workspace = "w[tv1]",
    gaps_out = 0,
    gaps_in = 0
  }
)
hl.workspace_rule(
  {
    workspace = "f[1]",
    gaps_out = 0,
    gaps_in = 0
  }
)

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule(
  {
    name = "ignore-maximize-requests",
    suppress_event = "maximize",
    match = {
      class = ".*"
    }
  }
)

-- All floating windows are centered by default (avoiding steam's popups):
hl.window_rule(
  {
    name = "centered-float",
    center = true,
    match = {
      float = true,
      title = "negative:^$|vmware|anydesk"
    }
  }
)



--- Xwayland hacks
-------------------------------------------------------------------------------

-- Fix some dragging issues with XWayland:
hl.window_rule(
  {
    name = "xwayland-drag",
    no_focus = true,
    match = {
      class = "^$",
      title = "^$",
      xwayland = true,
      float = true,
      fullscreen = false,
      pin = false
    }
  }
)

-- Screen sharing:
hl.window_rule(
  {
    name = "xwayland-screensharing",
    opacity = 0.0,
    no_anim = true,
    no_initial_focus = true,
    max_size = "1 1",
    no_blur = true,
    no_focus = true,
    match = {
      class = "^xwaylandvideobridge$"
    }
  }
)



--- Per-application rules
-------------------------------------------------------------------------------

-- Portals dialogues should always be floating:
hl.window_rule(
  {
    name = "portals-good",
    float = true,
    size = "800 500",
    match = {
      class= "xdg-desktop-portal-gtk"
    }
  }
)

-- However, some won't identify themselves as portals, so:
hl.window_rule(
  {
    name = "portals-bad",
    float = true,
    size = "800 500",
    match = {
      title = "^(Choose|Export|Open|Save) (Attachment|File|Folder|Project)s?$"
    }
  }
)

-- Claws-mail's address book should be a popup:
hl.window_rule(
  {
    name = "claws-mail-addressbook",
    float = true,
    size = "800 500",
    match = {
      class = "claws-mail",
      title = ".*[Aa]ddress book$"
    }
  }
)

-- Evolution's notifications must be small floating windows:
hl.window_rule(
  {
    name = "evolution-notifications",
    float = true,
    size = "800 500",
    match = {
      class = "evolution-alarm-notify"
    }
  }
)

-- Evolution's popupups must be a small floating window, but messages must be
-- not:
hl.window_rule(
  {
    name = "evolution-popups",
    float = true,
    size = "500 300",
    no_initial_focus = true,
    match = {
      class = "org.gnome.Evolution",
      title = "negative:^(Fwd|Re|Compose).*|.*Evolution$"
    }
  }
)

-- Godot's floating windows should have a fixed size:
hl.window_rule(
  {
    name = "godot-floating",
    size = "800 500",
    match = {
      float = true,
      initial_class = "^org.godotengine.*"
    }
  }
)

-- Netbeans's starting splash screen is evil:
hl.window_rule(
  {
    name = "netbeans-splash",
    tile = true,
    match = {
      class = "^Apache NetBeans.*",
      initial_title = "^Apache NetBeans IDE.*"
    }
  }
)

-- Screen recorder overlay must be floating:
hl.window_rule(
  {
    name = "wfrecorder",
    float = true,
    match = {
      class = "org.wf.recorder.gui"
    }
  }
)

-- This wine's popup should always be floating:
hl.window_rule(
  {
    name = "wine",
    float = true,
    match = {
      class = "wineboot.exe"
    }
  }
)



--- Workspace pinning
-------------------------------------------------------------------------------

-- Workspace 1:
hl.window_rule(
  {
    name = "w01-vivaldi",
    workspace = "1 silent",
    match = {
      class = "[Vv]ivaldi-stable"
    }
  }
)

hl.window_rule(
  {
    name = "w01-firefox",
    workspace = "1 silent",
    match = {
      class = "firefox"
    }
  }
)

hl.window_rule(
  {
    name = "w01-cherrytree",
    workspace = "1 silent",
    match = {
      class = "cherrytree"
    }
  }
)

hl.window_rule(
  {
    name = "w01-claws-mail",
    workspace = "1 silent",
    match = {
      class = "claws-mail"
    }
  }
)

hl.window_rule(
  {
    name = "w01-evolution",
    workspace = "1 silent",
    match = {
      class = "(org.gnome.Evolution|evolution-alarm-notify)"
    }
  }
)



-- Workspace 2:
hl.window_rule(
  {
    name = "w02-discord",
    workspace = "2 silent",
    no_screen_share = true,
    match = {
      class = "discord"
    }
  }
)

hl.window_rule(
  {
    name = "w02-telegram",
    workspace = "2 silent",
    no_screen_share = true,
    match = {
      class = "org.telegram.desktop"
    }
  }
)

hl.window_rule(
  {
    name = "w02-signal",
    workspace = "2 silent",
    no_screen_share = true,
    match = {
      class = "signal"
    }
  }
)

hl.window_rule(
  {
    name = "w02-whatsie",
    workspace = "2 silent",
    no_screen_share = true,
    match = {
      class = "com.ktechpit.whatsie"
    }
  }
)



-- Workspace 3:
hl.window_rule(
  {
    name = "w03-netbeans",
    workspace = "3 silent",
    match = {
      class = "^Apache NetBeans.*"
    }
  }
)

hl.window_rule(
  {
    name = "w03-netbeans-ide",
    workspace = "3 silent",
    match = {
      class = "java-lang-Thread",
      title = "Starting Apache NetBeans IDE"
    }
  }
)

hl.window_rule(
  {
    name = "w03-bruno",
    workspace = "3 silent",
    match = {
      class = "bruno"
    }
  }
)



-- Workspace 4:
hl.window_rule(
  {
    name = "w04-bitwarden",
    workspace = "4 silent",
    no_screen_share = true,
    match = {
      class = "Bitwarden"
    }
  }
)

hl.window_rule(
  {
    name = "w04-lm-studio",
    workspace = "4 silent",
    no_screen_share = true,
    match = {
      class = "LM-Studio"
    }
  }
)



-- Workspaces 5-6 are lawless.



-- Workspace 7:
hl.window_rule(
  {
    name = "w07-vmware",
    workspace = "7 silent",
    match = {
      class = "Vmware"
    }
  }
)



-- Workspace 8:
hl.window_rule(
  {
    name = "w08-deluge",
    workspace = "8 silent",
    match = {
      class = "deluge"
    }
  }
)



-- Workspace 9:
hl.window_rule(
  {
    name = "w09-godot",
    workspace = "9 silent",
    match = {
      class = "(org.godotengine.*|Godot)"
    }
  }
)



--- Workspace 10: the gaming one
-------------------------------------------------------------------------------

-- Remove workspace fluff:
hl.workspace_rule(
  {
    workspace = "10",
    gaps_in = 0,
    gaps_out = 0,
    no_border = true,
    no_rounding = true,
    no_shadow = true,
    decorate = false
  }
)

-- Remove window fluff:
hl.window_rule(
  {
    name = "w10-no-decorations",
    no_anim = true,
    no_blur = true,
    no_dim = true,
    match = {
      workspace = "10"
    }
  }
)

-- All windows are floating, except Steam's main window:
hl.window_rule(
  {
    name = "w10-all-floating",
    float = true,
    match = {
      workspace = "10",
      title = "negative:^Steam$"
    }
  }
)

-- Attempt to make all non-launchers fullscreen:
hl.window_rule(
  {
    name = "w10-non-launchers",
    fullscreen = true,
    match = {
      workspace = "10",
      title = "negative:^(Origin|Ubisoft|Uplay|Steam).*",
      class = "negative:^[Ss]team$"
    }
  }
)

-- Attempt to pin game launchers in here:
hl.window_rule(
  {
    name = "w10-steam-class",
    workspace = "10 silent",
    match = {
      class = "[Ss]team(webhelper|_app_.*)?"
    }
  }
)

hl.window_rule(
  {
    name = "w10-steam-title",
    workspace = "10 silent",
    match = {
      title = "^Steam$"
    }
  }
)

hl.window_rule(
  {
    name = "w10-launchers",
    workspace = "10 silent",
    match = {
      title = "^(Origin|Ubisoft|Uplay).*"
    }
  }
)

