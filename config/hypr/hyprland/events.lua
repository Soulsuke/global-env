--- Events
-------------------------------------------------------------------------------



--- Workspace events
-------------------------------------------------------------------------------

--- Special rules on creation:
hl.on(
  "workspace.created",
  function( ws )
    -- The special 'terminal' workspace should always spawn kitty if it's
    -- empty:
    if ws.name == "special:terminal" and ws.is_empty then
      hl.exec_cmd( terminal, { workspace = "special:terminal silent" } )
    end
  end
)

