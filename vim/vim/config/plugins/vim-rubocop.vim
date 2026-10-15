" If there's one in the current folder:
if filereadable( getcwd() . "/.rubocop.yml" )
  let g:vimrubocop_config = getcwd() . "/.rubocop.yml"

" Othewrwise, if we're in a Rails project check if there's one in its root:
elseif !empty( get( g:, "ruby_root", "" ) ) &&
\      filereadable( g:ruby_root . "/.rubocop.yml" )
  let g:vimrubocop_config = g:ruby_root . "/.rubocop.yml"

" Otherwise use the default one:
else
  let g:vimrubocop_config = "~/.vim/resources/rubocop.yml"
endif

