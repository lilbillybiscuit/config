let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let g:vim_config_bootstrap_plugins = 0
let g:vim_config_plug_path = '/tmp/vim-config-no-plug.vim'
let g:vim_config_undo_dir = '/tmp/vim-config-editing-test-undo'

execute 'source ' . fnameescape(s:root . '/vimrc')

function! AutoPairsReturn() abort
  return ''
endfunction
let b:autopairs_enabled = 1

call setline(1, '')
call feedkeys("iabc\<CR>def\<Esc>", 'xt')
call assert_equal(['abc', 'def'], getline(1, '$'))

enew!
call feedkeys("i\<Tab>\<S-Tab>X\<Esc>", 'xt')
call assert_equal('X', getline(1))

enew!
call feedkeys("iabc\<S-Tab>X\<Esc>", 'xt')
call assert_equal('abcX', getline(1))

for [s:extension, s:filetype] in items({
      \ 'C': 'cpp',
      \ 'c': 'c',
      \ 'cc': 'cpp',
      \ 'cpp': 'cpp',
      \ 'cxx': 'cpp',
      \ 'hh': 'cpp',
      \ 'hpp': 'cpp',
      \ 'hxx': 'cpp',
      \ 'mm': 'objcpp',
      \ 'tpp': 'cpp',
      \ })
  execute 'edit ' . fnameescape(tempname() . '.' . s:extension)
  call assert_equal(s:filetype, &filetype, s:extension)
  bwipeout!
endfor

execute 'edit ' . fnameescape(tempname() . '.cpp')
call assert_equal('', maparg('}', 'i'))
call assert_match('Enter', maparg('<CR>', 'i'))
call assert_match('Tab', maparg('<Tab>', 'i'))
call assert_match('ShiftTab', maparg('<S-Tab>', 'i'))
bwipeout!

" With the real auto-pairs, Enter between paired braces must leave the closing
" brace aligned with the statement rather than with a continuation line, and a
" typed } must still skip over the auto-inserted one.
let s:auto_pairs = empty($VIM_CONFIG_TEST_AUTO_PAIRS)
      \ ? g:vim_config_plugin_home . '/auto-pairs'
      \ : $VIM_CONFIG_TEST_AUTO_PAIRS
if filereadable(s:auto_pairs . '/plugin/auto-pairs.vim')
  execute 'set runtimepath^=' . fnameescape(s:auto_pairs)
  runtime plugin/auto-pairs.vim

  execute 'edit ' . fnameescape(tempname() . '.cpp')
  call assert_equal(1, get(b:, 'autopairs_enabled', 0))
  call feedkeys("iif (some_long_condition &&\<CR>another_condition) {\<CR>return 1;\<Esc>", 'xt')
  call assert_equal([
        \ 'if (some_long_condition &&',
        \ '        another_condition) {',
        \ '    return 1;',
        \ '}',
        \ ], getline(1, '$'))
  bwipeout!

  execute 'edit ' . fnameescape(tempname() . '.cpp')
  call feedkeys("iint a[] = {1};\<Esc>", 'xt')
  call assert_equal('int a[] = {1};', getline(1))
  bwipeout!
else
  echom 'auto-pairs not found at ' . s:auto_pairs . '; skipping the paired-brace check'
endif

if !empty(v:errors)
  call writefile(v:errors, '/tmp/vim-config-editing-test-errors')
  cquit
endif

qa!
