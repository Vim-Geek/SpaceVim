let s:WIN = SpaceVim#api#import('vim#window')
" we can not use this option to disable default key bindings
" let g:nvim_tree_disable_default_keybindings = 1
augroup vfinit
  au!
  autocmd FileType NvimTree call s:nvim_tree_init()
  autocmd BufEnter * nested if
        \ (!has('vim_starting') && s:WIN.win_count() == 1  && g:_spacevim_autoclose_filetree
        \ && &filetype ==# 'NvimTree') |
        \ call s:close_last_filetree() | endif
augroup END
function! s:close_last_filetree() abort
  call SpaceVim#layers#shell#close_terminal()
  q
endfunction
function! s:nvim_tree_init() abort
  nnoremap <silent><buffer> . :<C-u>lua require'nvim-tree.actions'.on_keypress('toggle_dotfiles')<Cr>
endfunction

lua require('config.nvim-tree')
