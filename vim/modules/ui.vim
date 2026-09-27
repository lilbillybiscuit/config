" Colors, separators, status and tab lines, and terminal-window presentation.
" Colors are Catppuccin Frappe to match Ghostty.
set background=dark
if exists('+termguicolors')
  set termguicolors
endif

if !empty(globpath(&runtimepath, 'colors/catppuccin_frappe.vim'))
  colorscheme catppuccin_frappe
endif

if exists('+fillchars')
  set fillchars=vert:┃,fold:─,diff:╱
endif

" The mode is drawn in the status line instead.
set noshowmode

" Neovim draws separators with WinSeparator; Vim still uses VertSplit.
let s:separator_groups = ['VertSplit', 'WinSeparator']

" Highlight-group suffix -> [gui color, cterm color] for each mode's label.
let s:mode_colors = {
      \ 'Normal': ['#ca9ee6', 183],
      \ 'Insert': ['#a6d189', 150],
      \ 'Visual': ['#ef9f76', 216],
      \ 'Replace': ['#e78284', 210],
      \ 'Command': ['#e5c890', 223],
      \ 'Terminal': ['#81c8be', 116],
      \ }

function! s:ApplyHighlights() abort
  highlight StatusLine   cterm=bold ctermfg=189 ctermbg=237 gui=bold guifg=#c6d0f5 guibg=#414559
  highlight StatusLineNC cterm=none ctermfg=146 ctermbg=236 gui=none guifg=#a5adce guibg=#292c3c
  highlight TabLineSel   cterm=bold ctermfg=235 ctermbg=183 gui=bold guifg=#232634 guibg=#ca9ee6
  highlight TabLine      cterm=none ctermfg=146 ctermbg=237 gui=none guifg=#a5adce guibg=#414559
  highlight TabLineFill  cterm=none ctermbg=236 gui=none guibg=#292c3c
  for l:group in s:separator_groups
    execute 'highlight ' . l:group . ' cterm=none ctermfg=60 ctermbg=NONE gui=none guifg=#626880 guibg=NONE'
  endfor
  highlight VimConfigActiveSeparator cterm=bold ctermfg=183 ctermbg=NONE gui=bold guifg=#ca9ee6 guibg=NONE
  highlight VimConfigTerminal ctermfg=146 ctermbg=235 guifg=#a5adce guibg=#232634
  for [l:name, l:color] in items(s:mode_colors)
    execute printf('highlight VimConfigMode%s cterm=bold ctermfg=235 ctermbg=%d gui=bold guifg=#232634 guibg=%s',
          \ l:name, l:color[1], l:color[0])
  endfor
  if has('nvim')
    highlight! link WinBar VimConfigModeNormal
    highlight! link WinBarNC StatusLineNC
  endif
endfunction

call s:ApplyHighlights()

let s:modes = {
      \ 'n': ['NORMAL', 'Normal'],
      \ 'i': ['INSERT', 'Insert'],
      \ 'v': ['VISUAL', 'Visual'],
      \ 'V': ['V-LINE', 'Visual'],
      \ "\<C-v>": ['V-BLOCK', 'Visual'],
      \ 's': ['SELECT', 'Visual'],
      \ 'S': ['S-LINE', 'Visual'],
      \ "\<C-s>": ['S-BLOCK', 'Visual'],
      \ 'R': ['REPLACE', 'Replace'],
      \ 'c': ['COMMAND', 'Command'],
      \ 't': ['TERMINAL', 'Terminal'],
      \ }

" The mode label, with its highlight, for the window being drawn. Inactive
" windows get no label, which also marks which window has focus.
function! VimConfigMode() abort
  if get(g:, 'statusline_winid', win_getid()) != win_getid()
    return ''
  endif
  let [l:label, l:group] = get(s:modes, mode(), [toupper(mode()), 'Normal'])
  return '%#VimConfigMode' . l:group . '# ' . l:label . ' %#StatusLine# '
endfunction

" Like coc#status(), but also counts information and hint diagnostics and
" leads with the enclosing symbol.
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

let &statusline = '%{%VimConfigMode()%} %<%{expand(''%:~:h'')}/%t %h%m%r'
      \ . '%= %{VimConfigCocStatus()}%l:%c %p%% '

" Neovim: one status line at the bottom, and a title bar per window. The
" focused window's bar uses WinBar and the others WinBarNC.
if has('nvim')
  set laststatus=3
  let &winbar = '%=%m %f '
endif

" The active window's separators use the bright group. A window owns only its
" right and bottom borders. Vim has no 'winhighlight', so this is Neovim-only.
function! s:MarkSeparators(active) abort
  if !exists('+winhighlight')
    return
  endif
  for l:group in s:separator_groups
    execute 'setlocal winhighlight' . (a:active ? '+=' : '-=') . l:group . ':VimConfigActiveSeparator'
  endfor
endfunction

function! s:ConfigureTerminalWindow() abort
  setlocal nonumber norelativenumber nolist signcolumn=no
  let &l:statusline = ' '
  if exists('+winhighlight')
    setlocal winhighlight+=Normal:VimConfigTerminal
  endif
endfunction

augroup vim_config_ui
  autocmd!
  autocmd ColorScheme * call <SID>ApplyHighlights()
  autocmd WinEnter * call <SID>MarkSeparators(1) | setlocal cursorline
  autocmd WinLeave * call <SID>MarkSeparators(0) | setlocal nocursorline
  autocmd User CocStatusChange,CocDiagnosticChange redrawstatus
  if exists('##TermOpen')
    autocmd TermOpen * call <SID>ConfigureTerminalWindow()
  endif
  if exists('##TerminalOpen')
    autocmd TerminalOpen * call <SID>ConfigureTerminalWindow()
  endif
augroup END
