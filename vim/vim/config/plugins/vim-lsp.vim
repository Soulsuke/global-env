" If we are in a rails project, use its own ruby-lsp:
if !empty( g:rails_root )
  au User lsp_setup call lsp#register_server( {
  \   "name": "ruby-lsp",
  \   "cmd": {
  \     server_info -> [ g:rails_root . "/bin/bundle", "exec", "ruby-lsp" ]
  \   },
  \   "allowlist": [ "ruby" ],
  \   "root_uri": {
  \     server_info -> lsp#utils#path_to_uri( g:rails_root )
  \   }
  \ } )

" Otherwise use system-wide ruby-lsp if available:
elseif executable( "ruby-lsp" )
  au User lsp_setup call lsp#register_server( {
  \   "name": "ruby-lsp",
  \   "cmd": { server_info -> [ "ruby-lsp" ] },
  \   "allowlist": [ "ruby" ]
  \ } )
endif

