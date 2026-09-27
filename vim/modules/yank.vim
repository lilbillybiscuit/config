" Copy to the system clipboard through OSC52, which works over SSH and tmux.
" coc-yank flashes what was yanked and keeps a history.
xnoremap <silent> <leader>y :<C-u>call VimConfigRun("'<,'>OSCYankVisual", 'vim-oscyank', ':OSCYankVisual')<CR>
nnoremap <silent> <leader>yy :call VimConfigRun('call OSCYank(getline(".") . "\n")', 'vim-oscyank', '*OSCYank')<CR>
nnoremap <silent> <leader>yl :call VimConfigRun('CocList yank', 'coc-yank')<CR>
