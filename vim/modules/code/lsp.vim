" CoC adapter: turns lsp/defaults.vim, the profile's settings, and
" g:vim_config_paths into CoC's configuration, then maps language actions.
let g:coc_global_extensions = uniq(sort(copy(g:vim_config_coc_extensions)))

let s:settings = copy(g:vim_config_coc_settings)
for [s:tool, s:key] in [['clangd', 'clangd.path'], ['python3', 'python.pythonPath'],
      \ ['black', 'python.formatting.blackPath']]
  if !empty(g:vim_config_paths[s:tool]) && !has_key(s:settings, s:key)
    let s:settings[s:key] = g:vim_config_paths[s:tool]
  endif
endfor
let g:coc_user_config = s:settings
unlet s:settings s:tool s:key

if !empty(g:vim_config_paths.node)
  let g:coc_node_path = g:vim_config_paths.node
endif

function! s:Refresh() abort
  return get(g:, 'did_coc_loaded', 0) ? coc#refresh() : "\<C-Space>"
endfunction

function! s:ShowDocumentation() abort
  if index(['vim', 'help'], &filetype) >= 0
    execute 'help ' . expand('<cword>')
  else
    call VimConfigRun("call CocActionAsync('doHover')", 'CoC', '*CocActionAsync')
  endif
endfunction

function! s:CocAction(action) abort
  call VimConfigRun('call CocActionAsync(' . string(a:action) . ')', 'CoC', '*CocActionAsync')
endfunction

inoremap <silent><expr> <C-Space> <SID>Refresh()

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gD <Plug>(coc-declaration)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gl <Plug>(coc-codelens-action)
nmap <silent> <leader>i <Plug>(coc-diagnostic-info)
nmap <silent> <leader>R <Plug>(coc-rename)
nnoremap <silent> <leader>k :call VimConfigRun('CocDiagnostics', 'CoC')<CR>

nnoremap <silent> <leader>gs :call VimConfigRun('CocList -I symbols', 'CoC')<CR>
nnoremap <silent> <leader>d :call <SID>ShowDocumentation()<CR>
nnoremap <silent> <leader>f :call <SID>CocAction('format')<CR>
xmap <silent> <leader>f <Plug>(coc-format-selected)
nnoremap <silent> <leader>ac :call <SID>CocAction('codeAction')<CR>
nnoremap <silent> <leader>qf :call <SID>CocAction('quickfixes')<CR>

augroup vim_config_coc
  autocmd!
  autocmd CursorHold * if exists('*CocActionAsync') | call CocActionAsync('highlight') | endif
augroup END
