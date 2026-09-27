" A profile's paths, settings, and modules load in order and override the
" public defaults.
let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let g:vim_config_bootstrap_plugins = 0
let g:vim_config_plug_path = '/tmp/vim-config-no-plug.vim'
let g:vim_config_undo_dir = '/tmp/vim-config-profile-test-undo'
let g:vim_config_local_file = '/tmp/vim-config-no-local.vim'
let g:vim_config_profile_dir = s:root . '/tests/profile'

execute 'source ' . fnameescape(s:root . '/vimrc')

call assert_equal('/profile/bin/node', g:coc_node_path)
call assert_equal('/profile/bin/clangd', g:coc_user_config['clangd.path'])
call assert_equal(['--background-index'], g:coc_user_config['clangd.arguments'])
call assert_equal(v:false, g:coc_user_config['codeLens.enable'])
call assert_equal(v:true, g:coc_user_config['diagnostic.virtualText'])
call assert_true(index(g:coc_global_extensions, 'coc-tsserver') >= 0)
call assert_equal('/profile/bin/node', g:vim_config_test_profile_module)

" Re-sourcing starts from the defaults again instead of stacking additions.
execute 'source ' . fnameescape(s:root . '/vimrc')
call assert_equal(1, count(g:vim_config_coc_extensions, 'coc-tsserver'))

if !empty(v:errors)
  call writefile(v:errors, '/tmp/vim-config-profile-test-errors')
  cquit
endif

qa!
