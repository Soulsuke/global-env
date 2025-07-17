" Ruby project root path container:
let g:ruby_root = ""

" Bundle executable to use in this project:
let g:ruby_bundle = ""



"-- Ruby project root check
"------------------------------------------------------------------------------

" Control varialbes:
let s:root = getcwd()
let s:depth = 0

" Let's loop for a possible project root:
while s:root !=# "/" && s:depth < 5
  " Stop if we find either a Gemfile (ruby project) or a .git folder (repo
  " root):
  if filereadable( s:root . "/Gemfile" ) || isdirectory( s:root . "/.git" )
    " Set the ruby root:
    let g:ruby_root = s:root
    break
  endif

  " Otherwise, go up one:
  let s:root = fnamemodify( s:root, ":h" )
  let s:depth += 1
endwhile



"-- Bundle executable check
"------------------------------------------------------------------------------

" If the project contains /bin/bundle (as Rails projects do) use it:
if !empty( g:ruby_root ) && executable( g:ruby_root . "/bin/bundle" )
  let g:ruby_bundle = g:ruby_root . "/bin/bundle"

" Otherwise, use system-wide bundle if available:
elseif executable( "bundle" )
  let g:ruby_bundle = "bundle"
endif

