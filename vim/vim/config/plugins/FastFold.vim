" Settings:
let g:baan_fold = 1
let g:clojure_fold = 1
let g:fortran_fold = 1
let g:javaScript_fold = 1
let g:markdown_folding = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:php_folding = 1
let g:r_syntax_folding = 1
let g:rst_fold_enabled = 1
let g:ruby_fold = 1
let g:rust_fold = 1
let g:sh_fold_enabled = 7
let g:tex_fold_enabled = 1
let g:vimsyn_folding = 'af'
let g:xml_syntax_folding = 1
let g:zsh_fold_enable = 1

" Special folding methods:
autocmd FileType c,cpp setlocal foldmethod=syntax
autocmd FileType python setlocal foldmethod=indent

