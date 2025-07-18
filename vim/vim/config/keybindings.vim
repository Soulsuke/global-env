"------------------------------------------------------------------------------
"-- Function keys                                                            --
"------------------------------------------------------------------------------

" Toggle line numbers:
nmap <F2> :set invnumber<CR>

" Toggle folding:
inoremap <F4> <C-O>za
nnoremap <F4> za
onoremap <F4> <C-C>za
vnoremap <F4> zf



"------------------------------------------------------------------------------
"-- Leader                                                                   --
"------------------------------------------------------------------------------

" JSON beautifier (jq):
nnoremap <leader>j :%!jq '.'<CR>


" Copy yanked into wayland clipboard:
nnoremap <leader>y :call system( "wl-copy", @" )<CR>

" Quick git blame:
map <silent><Leader>g :call
\  setbufvar(
\    winbufnr(
\      popup_atcursor(
\        split(
\          system( "git log -n 1 -L " . line(".") . ",+1:" . expand("%:p") ),
\          "\n"
\        ),
\        { "padding": [1,1,1,1], "pos": "botleft", "wrap": 0 }
\      )
\    ),
\    "&filetype",
\    "git"
\  )<CR>



"------------------------------------------------------------------------------
"-- Others                                                                   --
"------------------------------------------------------------------------------

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>



"------------------------------------------------------------------------------
"-- Plugins                                                                  --
"------------------------------------------------------------------------------

"-- asyncomplete.vim
"------------------------------------------------------------------------------

" Next on tab:
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"

" Previous on shift-tab:
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Confirm on return:
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"



"-- fzf.vim
"------------------------------------------------------------------------------

" File search:
map F :Files<CR>



"-- NERDTree
"------------------------------------------------------------------------------

" Toggle:
map <leader>n :NERDTreeToggle<CR>



"-- vim-lsp
"------------------------------------------------------------------------------

" Optional: Keybindings for LSP features
function! s:on_lsp_buffer_enabled_keybindings() abort
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> K <plug>(lsp-hover)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [d <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]d <plug>(lsp-next-diagnostic)
endfunction
autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled_keybindings()



"-- vim-markdown
"------------------------------------------------------------------------------

" Let's not remap ge and use gl instead:
map <nowait> gl <Plug>Markdown_EditUrlUnderCursor



"-- vim-markdown-toc
"------------------------------------------------------------------------------

" Add index:
map <leader>i :GenTocGFM<CR>



"-- vim-prettier
"------------------------------------------------------------------------------

" Prettify:
map <leader>p :Prettier<CR>



"-- vim-rubocop
"------------------------------------------------------------------------------

" Check for violations:
map <leader>r :RuboCop<CR>

" Autofix violations:
map <leader>ra :RuboCop -a<CR>

" Formatter:
map <leader>rx :RuboCop -x<CR>



"-- vim-signify
"------------------------------------------------------------------------------

" Toggle:
map <leader>s :SignifyToggle<CR>

" Show whole file diff:
map <c-d> :SignifyDiff!<CR>

" Show hunk diff:
map <leader>d :SignifyHunkDiff<CR>

" Undo hunk diff:
map <leader>du :SignifyHunkUndo<CR>

" Jump to next hunk:
nmap <c-n> <plug>(signify-next-hunk)

" Jump to previous hunk:
nmap <c-p> <plug>(signify-prev-hunk)

