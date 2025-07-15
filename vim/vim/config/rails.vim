" Helper function to find out if the current folder is part of a Rails project.
function! s:get_rails_root() abort
  let l:root = getcwd()
  let l:depth = 0

  while l:root !=# "/" && l:depth < 5
    if filereadable( l:root . "/Gemfile" ) &&
    \  executable( l:root . "/bin/bundle" )
      return l:root
    else
      let l:root = fnamemodify( l:root, ":h" )
    endif
  endwhile

  return ""
endfunction

" Set this accordingly:
let g:rails_root = s:get_rails_root()

