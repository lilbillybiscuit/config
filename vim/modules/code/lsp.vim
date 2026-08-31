" CoC completion, diagnostics, language actions, and extensions.
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-clangd',
      \ 'coc-lists',
      \ 'coc-pyright',
      \ 'coc-sh',
      \ 'coc-yank',
      \ ]

let s:hrt_node = '/opt/hrt/hrtnodejs-24/bin/node'
if executable(s:hrt_node)
  let g:coc_node_path = get(g:, 'coc_node_path', s:hrt_node)
elseif executable('node')
  let g:coc_node_path = get(g:, 'coc_node_path', exepath('node'))
endif
unlet s:hrt_node

function! s:CheckBackspace() abort
  let l:column = col('.') - 1
  return !l:column || getline('.')[l:column - 1] =~# '\s'
endfunction

function! s:Tab() abort
  if exists('*coc#pum#visible') && coc#pum#visible()
    return coc#pum#confirm()
  endif
  if s:CheckBackspace()
    return "\<Tab>"
  endif
  return exists('*coc#refresh') ? coc#refresh() : "\<Tab>"
endfunction

function! s:ShiftTab() abort
  if exists('*coc#pum#visible') && coc#pum#visible()
    return coc#pum#prev(1)
  endif
  return "\<C-h>"
endfunction

function! s:Refresh() abort
  return exists('*coc#refresh') ? coc#refresh() : "\<C-Space>"
endfunction

function! s:ShowDocumentation() abort
  if index(['vim', 'help'], &filetype) >= 0
    execute 'help ' . expand('<cword>')
  elseif exists('*CocActionAsync')
    call CocActionAsync('doHover')
  else
    echohl WarningMsg | echom '[vim-config] CoC is not available' | echohl None
  endif
endfunction

function! s:CocAction(action) abort
  if exists('*CocActionAsync')
    call CocActionAsync(a:action)
  else
    echohl WarningMsg | echom '[vim-config] CoC is not available' | echohl None
  endif
endfunction

function! s:CocList(arguments) abort
  if exists(':CocList') == 2
    execute 'CocList ' . a:arguments
  else
    echohl WarningMsg | echom '[vim-config] CoC is not available' | echohl None
  endif
endfunction

inoremap <silent><expr> <Tab> <SID>Tab()
inoremap <silent><expr> <S-Tab> <SID>ShiftTab()
inoremap <silent><expr> <C-Space> <SID>Refresh()

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gD <Plug>(coc-declaration)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gl <Plug>(coc-codelens-action)

nnoremap <silent> <leader>gs :call <SID>CocList('-I symbols')<CR>
nnoremap <silent> <leader>d :call <SID>ShowDocumentation()<CR>
nnoremap <silent> <leader>f :call <SID>CocAction('format')<CR>
nnoremap <silent> <leader>ac :call <SID>CocAction('codeAction')<CR>
nnoremap <silent> <leader>qf :call <SID>CocAction('quickfixes')<CR>

augroup vim_config_coc
  autocmd!
  autocmd CursorHold * if exists('*CocActionAsync') | call CocActionAsync('highlight') | endif
augroup END
