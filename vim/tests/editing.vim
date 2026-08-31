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

if !empty(v:errors)
  call writefile(v:errors, '/tmp/vim-config-editing-test-errors')
  cquit
endif

qa!
