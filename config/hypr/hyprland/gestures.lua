-------------------------------------------------------------------------------
--- Gestures                                                                ---
-------------------------------------------------------------------------------

-- General setup
-- https://wiki.hypr.land/Configuring/Basics/Variables/#gestures
-------------------------------------------------------------------------------
hl.config(
  {
    gestures = {
      -- Allow worspace swiping:
      workspace_swipe_touch = true,

      -- Do not create new empty workspaces when swiping:
      workspace_swipe_create_new = false
    }
  }
)



-- Gestures definition
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-------------------------------------------------------------------------------


-- Directions:
--   swipe -> any swipe
--   horizontal -> horizontal swipe
--   vertical -> vertical swipe
--   left, right, up, down -> swipe directions
--   pinch -> any pinch
--   pinchin, pinchout -> directional pinch

-- Switch workspaces on horizontal scroll:
hl.gesture(
  {
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
  }
)

-- Show/hide terminal special workspace on vertical scroll:
hl.gesture(
  {
    fingers = 3,
    direction = "vertical",
    action = "special",
    arg = terminal
  }
)

