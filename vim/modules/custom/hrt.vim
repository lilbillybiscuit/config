" HRT-specific paths and Sourcegraph-style links.
let g:vim_config_sglink_root = get(g:, 'vim_config_sglink_root', getcwd())

function! s:SGLink() abort
  let l:file = resolve(expand('%:p'))
  let l:root = substitute(resolve(expand(g:vim_config_sglink_root)), '/$', '', '')
  if stridx(l:file, l:root . '/') == 0
    let l:file = strpart(l:file, strlen(l:root) + 1)
  else
    let l:file = substitute(l:file, '^/', '', '')
  endif
  let l:file = substitute(l:file, ' ', '%20', 'g')
  let l:url = 'http://go/dev/' . l:file . '#L' . line('.')
  echo l:url
endfunction

command! SGLink call <SID>SGLink()
