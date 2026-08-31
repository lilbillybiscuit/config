" Copy through the workstation's yank helper, with OSC52 kept on <leader>yy.
function! s:VisualText() abort
  let l:saved_register = getreg('"')
  let l:saved_type = getregtype('"')
  silent normal! gvy
  let l:text = getreg('"')
  call setreg('"', l:saved_register, l:saved_type)
  return l:text
endfunction

function! s:ExternalYank() abort
  let l:text = s:VisualText()
  if executable('yank') && filereadable('/dev/tty')
    call system('yank > /dev/tty', l:text)
  elseif exists(':OSCYank') == 2
    execute "'<,'>OSCYank"
  else
    echohl WarningMsg | echom '[vim-config] neither yank nor OSCYank is available' | echohl None
  endif
endfunction

function! s:OscYank() abort
  if exists(':OSCYank') == 2
    execute "'<,'>OSCYank"
  elseif executable('yank') && filereadable('/dev/tty')
    call system('yank > /dev/tty', s:VisualText())
  else
    echohl WarningMsg | echom '[vim-config] neither OSCYank nor yank is available' | echohl None
  endif
endfunction

function! s:OscYankLine() abort
  if exists(':OSCYankReg') == 2
    execute 'OSCYankReg "'
  elseif executable('yank') && filereadable('/dev/tty')
    call system('yank > /dev/tty', getline('.') . "\n")
  else
    echohl WarningMsg | echom '[vim-config] neither OSCYank nor yank is available' | echohl None
  endif
endfunction

xnoremap <silent> <leader>y :<C-u>call <SID>ExternalYank()<CR>
xnoremap <silent> <leader>yy :<C-u>call <SID>OscYank()<CR>
nnoremap <silent> <leader>yy :call <SID>OscYankLine()<CR>
