"-----------------------------------------------------------------------------"
"-- General settings                                                        --"
"-----------------------------------------------------------------------------"


function! s:on_lsp_buffer_enabled_settings() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled_settings()
augroup END



"-----------------------------------------------------------------------------"
"-- ruby-lsp                                                                --"
"-----------------------------------------------------------------------------"

" If we are in a rails project, use its own ruby-lsp:
if !empty( g:rails_root )
  au User lsp_setup call lsp#register_server( {
  \   "name": "ruby-lsp",
  \   "cmd": {
  \     server_info -> [
  \       "/bin/sh",
  \       "-c",
  \       "cd " . shellescape( g:rails_root ) . " && " .
  \         shellescape( g:rails_root ) . "/bin/bundle exec ruby-lsp"
  \     ]
  \   },
  \   "allowlist": [ "ruby", "eruby" ],
  \   "root_uri": {
  \     server_info -> lsp#utils#path_to_uri( g:rails_root )
  \   }
  \ } )

" Otherwise use system-wide ruby-lsp if available:
elseif executable( "ruby-lsp" )
  au User lsp_setup call lsp#register_server( {
  \   "name": "ruby-lsp",
  \   "cmd": { server_info -> [ "ruby-lsp" ] },
  \   "allowlist": [ "ruby", "eruby" ]
  \ } )
endif


