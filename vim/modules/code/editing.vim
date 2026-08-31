" Insert-mode policy, pairs, and comments.
let g:AutoPairsMapCR = 0
let g:AutoPairsMapSpace = 0

function! s:Newline() abort
  let l:keys = "\<C-g>u\<CR>"
  if exists('*AutoPairsReturn') && get(b:, 'autopairs_enabled', 0)
    let l:keys .= "\<C-r>=AutoPairsReturn()\<CR>"
  endif
  if get(g:, 'did_coc_loaded', 0)
    let l:keys .= "\<C-r>=coc#on_enter()\<CR>"
  endif
  return l:keys
endfunction

function! s:Enter() abort
  if get(g:, 'did_coc_loaded', 0) && coc#pum#visible()
    if coc#pum#has_item_selected()
      return coc#pum#confirm()
    endif
    return coc#pum#stop() . s:Newline()
  endif
  return s:Newline()
endfunction

function! s:CheckBackspace() abort
  let l:column = col('.') - 1
  return !l:column || getline('.')[l:column - 1] =~# '\s'
endfunction

function! s:Tab() abort
  if get(g:, 'did_coc_loaded', 0) && coc#pum#visible()
    return coc#pum#next(1)
  endif
  if s:CheckBackspace()
    return "\<Tab>"
  endif
  return get(g:, 'did_coc_loaded', 0) ? coc#refresh() : "\<Tab>"
endfunction

function! s:ShiftTab() abort
  if get(g:, 'did_coc_loaded', 0) && coc#pum#visible()
    return coc#pum#prev(1)
  endif
  return "\<C-d>"
endfunction

inoremap <silent><expr> <CR> <SID>Enter()
inoremap <silent><expr> <Tab> <SID>Tab()
inoremap <silent><expr> <S-Tab> <SID>ShiftTab()
nmap <silent> <leader>/ <Plug>CommentaryLine
xmap <silent> <leader>/ <Plug>Commentary
