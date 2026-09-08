let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let g:vim_config_bootstrap_plugins = 0
let g:vim_config_plug_path = '/tmp/vim-config-no-plug.vim'
let g:vim_config_undo_dir = '/tmp/vim-config-test-undo'
let g:vim_config_sglink_root = '/tmp'

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
call assert_match('VimConfigCocStatus', &statusline)
call assert_equal('', VimConfigCocStatus())
let g:did_coc_loaded = 1
call assert_equal('', VimConfigCocStatus())
let b:coc_diagnostic_info = {'error': 1, 'warning': 0, 'information': 2, 'hint': 3}
let g:coc_status = ' clangd: idle '
let b:coc_current_function = 'main'
call assert_equal('main E1 I2 H3 clangd: idle ', VimConfigCocStatus())
unlet g:did_coc_loaded g:coc_status b:coc_diagnostic_info b:coc_current_function
call assert_equal(1, exists('#vim_config_ui#User#CocStatusChange'))
call assert_equal(1, hlexists('VimConfigActiveSeparator'))
call assert_equal(2, exists(':SGLink'))
call assert_notmatch('/modules/.*/neovim.vim', execute('scriptnames'))
call assert_equal(
      \ ['coc-json', 'coc-clangd', 'coc-lists', 'coc-pyright', 'coc-sh', 'coc-yank'],
      \ g:coc_global_extensions)

if has('popupwin') && has('patch-8.2.191')
  call assert_equal(['window'], keys(g:fzf_layout))
  call assert_equal(0.9, g:fzf_layout.window.width)
else
  call assert_equal({'down': '~40%'}, g:fzf_layout)
endif
call assert_match('RunGitFiles', maparg('<Space>g', 'n'))
call assert_match('Run', maparg('<C-p>', 'n'))
call assert_match('Run', maparg('<Space>r', 'n'))
call assert_match('UpdatePlugins', maparg('<Space>pu', 'n'))
call assert_match('ExternalYank', maparg('<Space>y', 'x'))
call assert_match('OscYank', maparg('<Space>yy', 'x'))
call assert_match('OscYankLine', maparg('<Space>yy', 'n'))
call assert_match('ShowDocumentation', maparg('<Space>d', 'n'))
call assert_match('CocAction', maparg('<Space>f', 'n'))
call assert_match('coc-format-selected', maparg('<Space>f', 'x'))
call assert_match('coc-diagnostic-info', maparg('<Space>i', 'n'))
call assert_match('Diagnostics', maparg('<Space>k', 'n'))
call assert_equal('', maparg('<Space>gd', 'n'))

execute 'edit ' . fnameescape('/tmp/vim config sample.py')
let s:expected_link = 'http://go/dev/vim%20config%20sample.py#L1'
call assert_equal(s:expected_link, trim(execute('SGLink')))

" Re-sourcing must replace augroups and mappings instead of duplicating them.
execute 'source ' . fnameescape(s:root . '/vimrc')
call assert_match('ExternalYank', maparg('<Space>y', 'x'))
call assert_equal(1, exists('#vim_config_reload#BufEnter'))
call assert_equal(1, exists('#vim_config_coc#CursorHold'))

if !empty(v:errors)
  call writefile(v:errors, '/tmp/vim-config-test-errors')
  cquit
endif

qa!
