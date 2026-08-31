" Editing helpers: pairs, comments, and C-family brace indentation.
let g:AutoPairsMapCR = 0

function! s:Enter() abort
  if exists('*coc#pum#visible') && coc#pum#visible()
    return coc#pum#confirm()
  endif
  if exists('*AutoPairsReturn')
    return AutoPairsReturn()
  endif
  return "\<CR>"
endfunction

inoremap <silent><expr> <CR> <SID>Enter()
nmap <silent> <leader>/ <Plug>CommentaryLine
xmap <silent> <leader>/ <Plug>Commentary

augroup vim_config_c_braces
  autocmd!
  autocmd FileType c,cpp inoremap <buffer><silent> } }<Esc>==a
augroup END
