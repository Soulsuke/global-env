-------------------------------------------------------------------------------
--- Settings                                                                ---
-------------------------------------------------------------------------------

hl.config(
  {
    -- General
    -- See: https://wiki.hypr.land/Configuring/Basics/Variables/#general
    general = {
      -- Gaps between windows:
      gaps_in = 4,

      -- Gaps from screen edges:
      gaps_out = 8,

      -- Borders:
      border_size = 2,
      col = {
        active_border = wal_colors.foreground,
        inactive_border = wal_colors.invisible
      },

      -- Enable drag-n-drop resize:
      resize_on_border = true,

      -- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you
      -- turn this on:
      allow_tearing = false,

      -- Default layout:
      layout = "master",
    },

    -- Animations
    -- See:
    --  - https://wiki.hypr.land/Configuring/Basics/Variables/#animations
    --  - https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
    animations = {
      -- Let's keep them on:
      enabled = true,
    },

    -- Decorations
    -- See: https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
    decoration = {
      -- Border radius (in px) and smoothness:
      rounding = 10,
      rounding_power = 2,

      -- Transparency of focused/unfocused windows:
      active_opacity = 1.0,
      inactive_opacity = 1.0,

      -- Shadows:
      shadow = {
        enabled = false
      },

      -- Blur:
      blur = {
        enabled = false
      }
    },

    -- Misc
    -- See: https://wiki.hypr.land/Configuring/Basics/Variables/#misc
    misc = {
      -- Ensure middle click paste stays enabled:
      middle_click_paste = true,

      -- Disable autoreload (trigger manually via hyprctl reload):
      disable_autoreload = true,

      -- Disable random background:
      disable_hyprland_logo = true,

      -- Windows shouldn't steal focus:
      focus_on_activate = false,

      -- Ensure mouse and keyboard input will turn on screens:
      mouse_move_enables_dpms = true,
      key_press_enables_dpms = true
    },

    -- Layouts
    -- See: https://wiki.hypr.land/Configuring/Basics/Variables/#layout
    ---------------------------------------------------------------------------

    -- Dwindle layout
    -- See: https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
    dwindle = {
      -- You probably want this
      preserve_split = true
    },

    -- Master layout
    -- See: https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
    master = {
      -- Any new window is the master:
      new_status = "master",

      -- Tabs on top:
      orientation = "left",

      -- Master is huge:
      mfact = 0.75
    }
  }
)

