-------------------------------------------------------------------------------
--- Special workspaces definitions                                          ---
-------------------------------------------------------------------------------

--- Special workspace: floating
-------------------------------------------------------------------------------

-- All windows are floating and with a default size:
hl.window_rule(
  {
    name = "special-floating",
    float = true,
    size = "800 500",
    match = {
      workspace = "special:floating"
    }
  }
)

-- Toggle and moveto bindings:
hl.bind(
  mod .. " + S",
  hl.dsp.workspace.toggle_special( "floating" )
)
hl.bind(
  mod .. " + SHIFT + S",
  hl.dsp.window.move(
    {
      workspace = "special:floating",
      follow = false
    }
  )
)



--- Special workspace: terminal
-------------------------------------------------------------------------------

-- Toggle binding:
hl.bind(
  "F12",
  hl.dsp.workspace.toggle_special( "terminal" )
)

-- Toggle gesture:
hl.gesture(
  {
    fingers = 3,
    direction = "vertical",
    action = function()
      hl.dispatch( hl.dsp.workspace.toggle_special( "terminal" ) )
    end
  }
)

