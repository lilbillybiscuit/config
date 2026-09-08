" Colors, separators, status lines, and terminal-window presentation.
set background=dark
if exists('+termguicolors')
  set termguicolors
endif

let g:sonokai_style = 'default'
let g:sonokai_better_performance = 1
if !empty(globpath(&runtimepath, 'colors/sonokai.vim'))
  colorscheme sonokai
endif

if exists('+fillchars')
  set fillchars=vert:┃,fold:─,diff:╱
endif

" Neovim draws separators with WinSeparator; Vim still uses VertSplit.
let s:separator_groups = ['VertSplit', 'WinSeparator']

function! s:ApplyHighlights() abort
  highlight StatusLine   cterm=bold ctermfg=231 ctermbg=60 gui=bold guifg=#f8f8f2 guibg=#5f4b8b
  highlight StatusLineNC cterm=none ctermfg=250 ctermbg=236 gui=none guifg=#b8b8b8 guibg=#303030
  for l:group in s:separator_groups
    execute 'highlight ' . l:group . ' cterm=none ctermfg=99 ctermbg=NONE gui=none guifg=#875fd7 guibg=NONE'
  endfor
  highlight VimConfigActiveSeparator cterm=bold ctermfg=183 ctermbg=NONE gui=bold guifg=#d7afff guibg=NONE
  highlight VimConfigTerminal ctermfg=250 ctermbg=234 guifg=#c6c6c6 guibg=#1c1c1c
endfunction

call s:ApplyHighlights()

" Like coc#status(), but also counts information and hint diagnostics and
" leads with the enclosing symbol. b:coc_current_function only updates when
" coc.preferences.currentFunctionSymbolAutoUpdate is enabled in coc-settings.
function! VimConfigCocStatus() abort
  if !get(g:, 'did_coc_loaded', 0)
    return ''
  endif
  let l:parts = []
  let l:function = trim(get(b:, 'coc_current_function', ''))
  if !empty(l:function)
    call add(l:parts, l:function)
  endif
  let l:info = get(b:, 'coc_diagnostic_info', {})
  for [l:sign, l:key] in [['E', 'error'], ['W', 'warning'], ['I', 'information'], ['H', 'hint']]
    if get(l:info, l:key, 0) > 0
      call add(l:parts, l:sign . l:info[l:key])
    endif
  endfor
  let l:servers = trim(get(g:, 'coc_status', ''))
  if !empty(l:servers)
    call add(l:parts, l:servers)
  endif
  return empty(l:parts) ? '' : join(l:parts, ' ') . ' '
endfunction

let &statusline = '%#StatusLine# %<%{expand(''%:~:h'')}/'
      \ . '%#StatusLine#%t %h%m%r'
      \ . '%= %{VimConfigCocStatus()}%l:%c %p%% '

" Only the active window's separators use the bright group, which shows which
" pane owns a border. Vim has no 'winhighlight', so this is Neovim-only.
function! s:MarkSeparators(active) abort
  if !exists('+winhighlight')
    return
  endif
  for l:group in s:separator_groups
    execute 'setlocal winhighlight' . (a:active ? '+=' : '-=') . l:group . ':VimConfigActiveSeparator'
  endfor
endfunction

function! s:ConfigureTerminalWindow() abort
  setlocal nonumber norelativenumber
  let &l:statusline = ' '
  if exists('+winhighlight')
    setlocal winhighlight+=Normal:VimConfigTerminal
  endif
endfunction

augroup vim_config_ui
  autocmd!
  autocmd ColorScheme * call <SID>ApplyHighlights()
  autocmd WinEnter,BufEnter * redrawstatus
  autocmd WinLeave * redrawstatus
  autocmd WinEnter * call <SID>MarkSeparators(1)
  autocmd WinLeave * call <SID>MarkSeparators(0)
  autocmd User CocStatusChange,CocDiagnosticChange redrawstatus
  if exists('##TermOpen')
    autocmd TermOpen * call <SID>ConfigureTerminalWindow()
  endif
  if exists('##TerminalOpen')
    autocmd TerminalOpen * call <SID>ConfigureTerminalWindow()
  endif
augroup END
