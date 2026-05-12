-------------------------------------------------------------------------------
--- Input                                                                   ---
--- https://wiki.hypr.land/Configuring/Basics/Variables/#input              ---
-------------------------------------------------------------------------------

hl.config(
  {
    input = {
      -- Keyboard options (what xorg used to do):
      kb_layout = "it",
      kb_options = "compose:menu",

      -- Always follow the mouse:
      follow_mouse = 1,

      -- No mouse acceleration:
      sensitivity = 0,

      -- Touchpad:
      touchpad = {
        -- Scroll as God commands:
        natural_scroll = false,

        -- Enable middle button emulation with left+right:
        middle_button_emulation	= true,

        -- I hate this option, but I'll use as a container for the status of
        -- the whole touchpad being enabled/disabled.
        -- So... Do not change this.
        -- See: scripts/touchpad_toggle.zsh
        disable_while_typing = false
      }
    }
  }
)

