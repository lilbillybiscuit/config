let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let g:vim_config_bootstrap_plugins = 0
let g:vim_config_plug_path = '/tmp/vim-config-no-plug.vim'
let g:vim_config_undo_dir = '/tmp/vim-config-test-undo'
let g:vim_config_local_file = '/tmp/vim-config-no-local.vim'

execute 'source ' . fnameescape(s:root . '/vimrc')

call assert_equal(s:root, g:vim_config_root)
call assert_equal(' ', mapleader)
call assert_equal(4, &tabstop)
call assert_equal(4, &shiftwidth)
call assert_equal(-1, &softtabstop)
call assert_equal(1, &expandtab)
call assert_equal(1, &number)
call assert_equal(0, &modeline)
call assert_equal(1, &confirm)
call assert_equal('VimConfigCocStatus', g:lightline.component_function.coc)
call assert_equal('', VimConfigCocStatus())
let g:did_coc_loaded = 1
call assert_equal('', VimConfigCocStatus())
let b:coc_diagnostic_info = {'error': 1, 'warning': 0, 'information': 2, 'hint': 3}
let g:coc_status = ' clangd: idle '
let b:coc_current_function = 'main'
call assert_equal('main E1 I2 H3 clangd: idle', VimConfigCocStatus())
unlet g:did_coc_loaded g:coc_status b:coc_diagnostic_info b:coc_current_function
call assert_equal(1, exists('#vim_config_ui#User#CocStatusChange'))
call assert_equal(1, hlexists('VimConfigActiveSeparator'))
" No hex colors outside the color scheme: highlights only link to its groups.
call assert_notmatch('#\x\{6}', join(readfile(s:root . '/modules/ui.vim'), "\n"))
call assert_equal(0, &showmode)
call assert_equal([1, 1, 1, 1], [&ignorecase, &smartcase, &incsearch, &hlsearch])
call assert_equal('yes', &signcolumn)
call assert_equal(10, &ttimeoutlen)
call assert_notmatch('/modules/.*/neovim.vim', execute('scriptnames'))
call assert_equal(
      \ ['coc-clangd', 'coc-git', 'coc-json', 'coc-lists', 'coc-pyright', 'coc-sh', 'coc-yank'],
      \ g:coc_global_extensions)
call assert_equal(v:true, g:coc_user_config['coc.preferences.currentFunctionSymbolAutoUpdate'])
call assert_false(has_key(g:coc_user_config, 'python.pythonPath'))
call assert_equal(exepath('node'), g:vim_config_paths.node)
call assert_notmatch('--exact', $FZF_DEFAULT_OPTS)

" No config file hard-codes a binary path; paths.vim is the only place.
let s:files = [s:root . '/vimrc'] + glob(s:root . '/modules/**/*.vim', 0, 1) + glob(s:root . '/lsp/*.vim', 0, 1)
call assert_true(len(s:files) > 10)
for s:file in s:files
  call assert_notmatch('\v/(opt|usr)/', join(readfile(s:file), "\n"), s:file)
endfor

if has('popupwin') && has('patch-8.2.191')
  call assert_equal(['window'], keys(g:fzf_layout))
  call assert_equal(0.9, g:fzf_layout.window.width)
else
  call assert_equal({'down': '~40%'}, g:fzf_layout)
endif
call assert_match('GFiles', maparg('<Space>gf', 'n'))
call assert_match('git.showCommit', maparg('<Space>gc', 'n'))
call assert_equal('', maparg('gc', 'n'))
call assert_match('Files', maparg('<C-p>', 'n'))
call assert_match("'Rg'", maparg('<Space>r', 'n'))
call assert_match('Buffers', maparg('<Space>b', 'n'))
call assert_match('BLines', maparg('<Space>l', 'n'))
call assert_match('History', maparg('<Space>h', 'n'))
call assert_match('cword', maparg('<Space>*', 'n'))
call assert_match('PlugUpdate', maparg('<Space>pu', 'n'))
call assert_match('OSCYankVisual', maparg('<Space>y', 'x'))
call assert_equal('', maparg('<Space>yy', 'x'))
call assert_match('OSCYank(', maparg('<Space>yy', 'n'))
call assert_match('CocList yank', maparg('<Space>yl', 'n'))
call assert_match('coc-rename', maparg('<Space>R', 'n'))
call assert_match('ShowDocumentation', maparg('<Space>d', 'n'))
call assert_match('CocAction', maparg('<Space>f', 'n'))
call assert_match('coc-format-selected', maparg('<Space>f', 'x'))
call assert_match('coc-diagnostic-info', maparg('<Space>i', 'n'))
call assert_match('Diagnostics', maparg('<Space>k', 'n'))
call assert_equal('', maparg('<Space>gd', 'n'))

" A missing dependency warns instead of failing.
call assert_match('nothing-here is not available',
      \ execute("call VimConfigRun('NoSuchCommand', 'nothing-here')"))

" Re-sourcing must replace augroups and mappings instead of duplicating them.
execute 'source ' . fnameescape(s:root . '/vimrc')
call assert_match('OSCYankVisual', maparg('<Space>y', 'x'))
call assert_equal(1, exists('#vim_config_reload#BufEnter'))
call assert_equal(1, exists('#vim_config_coc#CursorHold'))

if !empty(v:errors)
  call writefile(v:errors, '/tmp/vim-config-test-errors')
  cquit
endif

qa!
