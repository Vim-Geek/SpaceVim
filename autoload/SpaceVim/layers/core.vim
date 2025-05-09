"=============================================================================
" core.vim --- SpaceVim core layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

""
" @section core, layers-core
" @parentsection layers
" The `core` layer of SpaceVim. This layer is enabled by default,
" and it provides filetree, comment key bindings etc.
"
" @subsection options
" 1. `filetree_show_hidden`: option for showing hidden file in filetree,
"   disabled by default.
" 2. `enable_smooth_scrolling`: enable/disabled smooth scrolling key bindings,
"   enabled by default.
" 3. `enable_filetree_gitstatus`: enable/disable git status column in filetree.
" 4. `enable_filetree_filetypeicon`: enable/disable filetype icons in filetree.
" 5. `enable_netrw`: enable/disable netrw, disabled by default.
" 6. `enable_quickfix_key_bindings`: enable/disable quickfix.nvim, mappings
" for neovim quickfix window. This option is only for neovim.
" 7. `enable_winbar`: enable/disable `wsdjeg/winbar.nvim`
"
" NOTE: the `enable_vimfiler_gitstatus` and `enable_filetree_gitstatus` option
" has been deprecated. Use layer option instead.
" *spacevim-options-enable_vimfiler_gitstatus*
" *spacevim-options-enable_filetree_gitstatus*
" *g:spacevim_enable_vimfiler_gitstatus*
" *g:spacevim_enable_filetree_gitstatus*
" *g:spacevim_enable_vimfiler_filetypeicon*

if exists('s:string_hi')
  finish
endif

""
" @section File Tree, usage-file-tree
" @parentsection usage
" The default filetree is `nerdtree`, and the default key binding is `<F3>`.
" SpaceVim also provides `SPC f t` and `SPC f T` to open the file tree.
" 
" The option @section(options-filemanager) can be used to change file
" manager plugin. For example:
" >
"   [options]
"     # file manager plugins supported in SpaceVim:
"     # - nerdtree (default)
"     # - vimfiler: you need to build the vimproc.vim in bundle/vimproc.vim directory
"     # - defx: requires +py3 feature
"     # - neo-tree: require neovim 0.7.0
"     filemanager = "nerdtree"
" <
" 
" VCS integration is also supported, there will be a column status,
" this feature may make filetree slow, so it is not enabled by default.
" To enable this feature, add the layer option `enable_filetree_gitstatus = true`
" to core layer.
" >
"   [[layers]]
"     name = 'core'
"     enable_filetree_gitstatus = true
" <
" 
" There is also an option to configure whether open filetree when startup.
" This is enabled by defaul, To disable this feature, you can set the
" @section(options-enable_vimfiler_welcome) to false:
" >
"   [options]
"     enable_vimfiler_welcome = false
" <
" 
" There is also an option to configure the side of the file tree,
" by default it is right. To move the file tree to the left,
" you can use the option: @section(options-filetree_direction).
" >
"   [options]
"     filetree_direction = "left"
" <
" 
" @subsection File tree navigation
" 
" Navigation is centered on the `hjkl` keys with the hope of providing
" a fast navigation experience like in vifm(https://github.com/vifm):
" >
"   Key Bindings          | Descriptions
"   --------------------- | -------------------------------------------------
"    <F3>                 | Toggle file explorer
"    SPC f t              | Toggle file explorer
"    SPC f T              | Show file explorer
" <
" Key bindings in filetree windows:
" >
"    <Left>  /  h         | go to parent node and collapse expanded directory
"    <Down>  /  j         | select next file or directory
"    <Up>  /  k           | select previous file or directory
"    <Right>  /  l        | open selected file or expand directory
"    <Enter>              | open file or switch to directory
"    N                    | Create new file under cursor
"    r                    | Rename the file under cursor
"    d                    | Delete the file under cursor
"    K                    | Create new directory under cursor
"    y y                  | Copy file full path to system clipboard
"    y Y                  | Copy file to system clipboard
"    P                    | Paste file to the position under the cursor
"    .                    | Toggle hidden files
"    s v                  | Split edit
"    s g                  | Vertical split edit
"    p                    | Preview
"    i                    | Switch to directory history
"    v                    | Quick look
"    g x                  | Execute with vimfiler associated
"    '                    | Toggle mark current line
"    V                    | Clear all marks
"    >                    | increase filetree screenwidth
"    <                    | decrease filetree screenwidth
"    <Home>               | Jump to first line
"    <End>                | Jump to last line
"    Ctrl-h               | Switch to project root directory
"    Ctrl-r               | Redraw
" <
" 
" @subsection Open file with file tree.
" 
" If only one file buffer is opened, a file is opened in the active window,
" otherwise we need to use vim-choosewin to select a window to open the file.
" >
"   Key Bindings    | Descriptions
"   --------------- | ----------------------------------------
"    l  /  <Enter>  | open file in one window
"    s g            | open file in a vertically split window
"    s v            | open file in a horizontally split window
" <
" @subsection Override filetree key bindings
" 
" If you want to override the default key bindings in filetree windows.
" You can use User autocmd in bootstrap function. for examples:
" >
"   function! myspacevim#before() abort
"       autocmd User NerdTreeInit
"           \ nnoremap <silent><buffer> <CR> :<C-u>call
"           \ g:NERDTreeKeyMap.Invoke('o')<CR>
"   endfunction
" <
" 
" Here is all the autocmd for filetree:
" 
" - nerdtree: `User NerdTreeInit`
" - defx: `User DefxInit`
" - vimfiler: `User VimfilerInit`


let s:enable_smooth_scrolling = 1
let s:enable_netrw = 0
let s:enable_quickfix_key_bindings = 0
let s:enable_winbar = 0

let g:_spacevim_enable_filetree_gitstatus = 0
let g:_spacevim_enable_filetree_filetypeicon = 0



let s:SYS = SpaceVim#api#import('system')
let s:FILE = SpaceVim#api#import('file')
let s:MESSAGE = SpaceVim#api#import('vim#message')
let s:CMP = SpaceVim#api#import('vim#compatible')
let s:NOTI = SpaceVim#api#import('notify')
let s:HI = SpaceVim#api#import('vim#highlight')


function! SpaceVim#layers#core#plugins() abort
  let plugins = []
  if !has('nvim')
    call add(plugins, [g:_spacevim_root_dir . 'bundle/nvim-yarp',  {'merged': 0}])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-hug-neovim-rpc',  {'merged': 0}])
  endif
  if has('timers') && has('float')
    " vim-smoothie needs +timers and +float
    call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-smoothie',  {'merged': 0, 'on_event' : 'BufReadPost'}])
  endif
  if g:spacevim_filemanager ==# 'nerdtree'
    call add(plugins, [g:_spacevim_root_dir . 'bundle/nerdtree', { 'merged' : 0,
          \ 'loadconf' : 1}])
    if g:_spacevim_enable_filetree_gitstatus
      call add(plugins, [g:_spacevim_root_dir . 'bundle/nerdtree-git-plugin', { 'merged' : 0,
            \ 'loadconf' : 1}])
    endif
  elseif g:spacevim_filemanager ==# 'vimfiler'
    call add(plugins, [g:_spacevim_root_dir . 'bundle/vimfiler.vim',{
          \ 'merged' : 0,
          \ 'loadconf' : 1 ,
          \ 'loadconf_before' : 1,
          \ 'on_cmd' : ['VimFiler', 'VimFilerBufferDir']
          \ }])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/unite.vim',{
          \ 'merged' : 0,
          \ 'loadconf' : 1
          \ }])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/vimproc.vim', {'build' : [(executable('gmake') ? 'gmake' : 'make')]}])
  elseif g:spacevim_filemanager ==# 'defx'
    call add(plugins, [g:_spacevim_root_dir . 'bundle/defx.nvim',{'merged' : 0, 'loadconf' : 1, 'on_cmd' : 'Defx'}])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/defx-git',{'merged' : 0, 'loadconf' : 1}])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/defx-icons',{'merged' : 0}])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/defx-sftp',{'merged' : 0}])
  elseif g:spacevim_filemanager ==# 'nvim-tree'
    call add(plugins, [g:_spacevim_root_dir . 'bundle/nvim-tree.lua',{'merged' : 0, 'loadconf' : 1, 'on_cmd' : ['NvimTreeOpen', 'NvimTree', 'NvimTreeToggle', 'NvimTreeFindFile']}])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/nvim-web-devicons',{'merged' : 0, 'loadconf' : 1}])
  elseif g:spacevim_filemanager ==# 'neo-tree'
    call add(plugins, [g:_spacevim_root_dir . 'bundle/neo-tree.nvim',{'merged' : 0, 'loadconf' : 1}])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/nui.nvim',{'merged' : 0}])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/nvim-web-devicons',{'merged' : 0, 'loadconf' : 1}])
  endif

  if !g:spacevim_vimcompatible
    call add(plugins, [g:_spacevim_root_dir . 'bundle/clever-f.vim', {'merged' : 0, 'on_map': '<Plug>(clever-f-'}])
    nmap f <Plug>(clever-f-f)
    xmap f <Plug>(clever-f-f)
    omap f <Plug>(clever-f-f)
    nmap F <Plug>(clever-f-F)
    xmap F <Plug>(clever-f-F)
    omap F <Plug>(clever-f-F)
    nmap t <Plug>(clever-f-t)
    xmap t <Plug>(clever-f-t)
    omap t <Plug>(clever-f-t)
    nmap T <Plug>(clever-f-T)
    xmap T <Plug>(clever-f-T)
    omap T <Plug>(clever-f-T)
  endif
  " call add(plugins, [g:_spacevim_root_dir . 'bundle/nerdcommenter', { 'loadconf' : 1, 'merged' : 0, 'on_map' : ['<Plug>NERDCommenter', '<Plug>Commenter']}])

  if exists('*matchaddpos')
    let g:loaded_matchit = 1
    call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-matchup', {'merged' : 0, 'on_event' : 'BufReadPost'}])
  endif
  call add(plugins, [g:_spacevim_root_dir . 'bundle/gruvbox', {'loadconf' : 1, 'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-clipboard', {'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/nvim-if-lua-compat', {'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/open-browser.vim', {
        \ 'merged' : 0, 'loadconf' : 1, 'on_cmd' : 'OpenBrowser',
        \}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-grepper' ,              { 'on_cmd' : 'Grepper',
        \ 'loadconf' : 1} ])

  if s:enable_quickfix_key_bindings
    call add(plugins, [g:_spacevim_root_dir . 'bundle/quickfix.nvim' ,              { 'merged' : 0} ])
  endif
  if s:enable_winbar
    call add(plugins, [g:_spacevim_root_dir . 'bundle/winbar.nvim' ,              { 'merged' : 0} ])
  endif
  if g:spacevim_flygrep_next_version && has('nvim-0.10.0')
    call add(plugins, [g:_spacevim_root_dir . 'bundle/flygrep.nvim' ,              { 'merged' : 0} ])
  endif
  return plugins
endfunction

let s:filename = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#core#config() abort

  if !s:enable_netrw
    " disabel netrw
    let g:loaded_netrwPlugin = 1
  endif


  if g:spacevim_filemanager ==# 'nerdtree'
    noremap <silent> <F3> :NERDTreeToggle<CR>
  elseif g:spacevim_filemanager ==# 'defx'
    nnoremap <silent> <F3> :Defx<Cr>
  elseif g:spacevim_filemanager ==# 'nvim-tree'
    nnoremap <silent> <F3> <cmd>NvimTreeToggle<CR>
  elseif g:spacevim_filemanager ==# 'neo-tree'
    nnoremap <silent> <F3> <cmd>NeoTreeFocusToggle<CR>
  endif
  let g:matchup_matchparen_status_offscreen = 0
  " Unimpaired bindings
  " Quickly add empty lines
  nnoremap <silent> [<Space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>
  nnoremap <silent> ]<Space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

  "]e or [e move current line ,count can be used
  nnoremap <silent>[e  :<c-u>execute 'move -1-'. v:count1<cr>
  nnoremap <silent>]e  :<c-u>execute 'move +'. v:count1<cr>

  " [b or ]n go to previous or next buffer
  nnoremap <silent> [b :<c-u>bN \| stopinsert<cr>
  nnoremap <silent> ]b :<c-u>bn \| stopinsert<cr>

  " [f or ]f go to next or previous file in dir
  nnoremap <silent> ]f :<c-u>call <SID>next_file()<cr>
  nnoremap <silent> [f :<c-u>call <SID>previous_file()<cr>

  " [l or ]l go to next and previous error
  nnoremap <silent> [l :lprevious<cr>
  nnoremap <silent> ]l :lnext<cr>

  " [c or ]c go to next or previous vcs hunk

  " [w or ]w go to next or previous window
  nnoremap <silent> [w :call <SID>previous_window()<cr>
  nnoremap <silent> ]w :call <SID>next_window()<cr>

  " [t or ]t for next and previous tab
  nnoremap <silent> [t :tabprevious<cr>
  nnoremap <silent> ]t :tabnext<cr>

  " [p or ]p for p and P
  nnoremap <silent> [p P
  nnoremap <silent> ]p p

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['f', 's'], 'call call('
        \ . string(s:_function('s:save_current_file')) . ', [])',
        \ ['save-current-file',
        \  ['[SPC f s] is to save current file',
        \   '',
        \   'Definition: ' . s:filename . ':' . lnum,
        \  ]
        \ ]
        \ , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'R'], 'call call('
        \ . string(s:_function('s:rename_current_file')) . ', [])',
        \ 'rename_current_file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'a'], 'call call('
        \ . string(s:_function('s:save_as_new_file')) . ', [])',
        \ 'save-as-new-file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'S'], 'wall', 'save-all-files', 1)
  " help mappings
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'I'], 'call SpaceVim#issue#report()', 'report-issue-or-bug', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'l'], 'SPLayer -l', 'list-all-layers', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'L'], 'SPRuntimeLog', 'view-runtime-log', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'k'], 'LeaderGuide "[KEYs]"', 'show-top-level-bindings', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', '0'], 'm`^', 'jump-to-beginning-of-line', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['j', '$'], 'm`g_', 'jump-to-end-of-line', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'b'], '<C-o>', 'jump-backward', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'f'], '<C-i>', 'jump-forward', 0)

  " file tree key bindings
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'd'], 'call call('
        \ . string(s:_function('s:explore_current_dir')) . ', [0])',
        \ 'explore-current-directory', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'D'], 'call call('
        \ . string(s:_function('s:explore_current_dir')) . ', [1])',
        \ 'split-explore-current-directory', 1)

  call SpaceVim#mapping#space#def('nnoremap', ['j', 'n'], "i\<cr>\<esc>", 'sp-newline', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'c'], 'call call('
        \ . string(s:_function('s:jump_last_change')) . ', [])',
        \ 'jump-to-last-change', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 's'], 'call call('
        \ . string(s:_function('s:split_string')) . ', [0])',
        \ 'split-sexp', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', '.'], 'call call('
        \ . string(s:_function('s:jump_transient_state')) . ', [])',
        \ 'jump-transient-state', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'S'], 'call call('
        \ . string(s:_function('s:split_string')) . ', [1])',
        \ 'split-and-add-newline', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'r'], 'call call('
        \ . string(s:_function('s:next_window')) . ', [])',
        \ 'rotate-windows-forward', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'R'], 'call call('
        \ . string(s:_function('s:previous_window')) . ', [])',
        \ 'rotate-windows-backward', 1)
  call SpaceVim#mapping#def('nnoremap <silent>', '<S-Tab>', ':wincmd p<CR>', 'Switch to previous window or tab','wincmd p')
  call SpaceVim#mapping#space#def('nnoremap', ['<Tab>'], 'try | b# | catch | endtry', 'last-buffer', 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['b', '.'], 'call call('
        \ . string(s:_function('s:buffer_transient_state')) . ', [])',
        \ ['buffer-transient-state',
        \ [
        \ '[SPC b .] is to open the buffer transient state',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'g'], 'call SpaceVim#plugins#helpgrep#help()',
        \ ['asynchronous-helpgrep',
        \ [
        \ '[SPC h g] is to run helpgrep asynchronously',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'G'],
        \ 'call SpaceVim#plugins#helpgrep#help(expand("<cword>"))',
        \ ['asynchronous-helpgrep-with-cword',
        \ [
        \ '[SPC h g] is to run helpgrep asynchronously with cword',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'd'],
        \ 'call SpaceVim#mapping#close_current_buffer()',
        \ ['delete-this-buffer',
        \ [
        \ '[SPC b d] is to delete current buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'D'],
        \ 'call SpaceVim#mapping#kill_visible_buffer_choosewin()',
        \ 'delete-the-selected-buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', '<C-d>'], 'call SpaceVim#mapping#clear_buffers()', 'kill-other-buffers', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', '<C-S-d>'], 'call SpaceVim#mapping#kill_buffer_expr()', 'kill-buffers-by-regexp', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'c'], 'call SpaceVim#mapping#clear_saved_buffers()', 'clear-all-saved-buffers', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'e'], 'call call('
        \ . string(s:_function('s:safe_erase_buffer')) . ', [])',
        \ 'safe-erase-buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'm'], 'call call('
        \ . string(s:_function('s:open_message_buffer')) . ', [])',
        \ 'open-message-buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'o'], 'call call('
        \ . string(s:_function('s:only_buf_win')) . ', [])',
        \ 'kill-other-buffers-and-windows', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'P'], 'normal! ggdG"+P', 'copy-clipboard-to-whole-buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'R'], 'call call('
        \ . string(s:_function('s:safe_revert_buffer')) . ', [])',
        \ 'safe-revert-buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'Y'], 'normal! ggVG"+y``', 'copy-whole-buffer-to-clipboard', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'w'], 'setl readonly!', 'read-only-mode', 1)
  let g:_spacevim_mappings_space.b.N = {'name' : '+New empty buffer'}
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'h'], 'topleft vertical new', 'new-empty-buffer-left', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'j'], 'rightbelow new', 'new-empty-buffer-below', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'k'], 'new', 'new-empty-buffer-above', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'l'], 'rightbelow vertical new', 'new-empty-buffer-right', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'n'], 'enew', 'new-empty-buffer', 1)

  " file mappings
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'b'], 'BookmarkShowAll', 'unite-filtered-bookmarks', 1)
  let g:_spacevim_mappings_space.f.C = {'name' : '+Files/convert'}
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'C', 'd'], 'update | e ++ff=dos | w', 'unix2dos', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'C', 'u'], 'update | e ++ff=dos | setlocal ff=unix | w', 'dos2unix', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'D'], 'call call('
        \ . string(s:_function('s:delete_current_buffer_file')) . ', [])',
        \ 'delete-current-buffer-file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', '/'], 'call SpaceVim#plugins#find#open()', 'find-files', 1)
  if s:SYS.isWindows
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'd'], 'call call('
          \ . string(s:_function('s:ToggleWinDiskManager')) . ', [])',
          \ 'toggle-disk-manager', 1)
  endif

  " file tree key bindings
  if g:spacevim_filemanager ==# 'vimfiler'
    call SpaceVim#mapping#space#def('nnoremap', ['f', 't'], 'VimFiler | doautocmd WinEnter', 'toggle-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'T'], 'VimFiler -no-toggle | doautocmd WinEnter', 'open-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'o'], 'VimFiler -find', 'find-file-in-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 't'], 'VimFilerBufferDir -no-toggle', 'open-filetree-in-buffer-dir', 1)
  elseif g:spacevim_filemanager ==# 'nerdtree'
    call SpaceVim#mapping#space#def('nnoremap', ['f', 't'], 'NERDTreeToggle', 'toggle-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'T'], 'NERDTree', 'show-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'o'], 'NERDTreeFind', 'open-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 't'], 'NERDTree %', 'show-file-tree-at-buffer-dir', 1)
  elseif g:spacevim_filemanager ==# 'defx'
    " TODO: fix all these command
    call SpaceVim#mapping#space#def('nnoremap', ['f', 't'], 'Defx', 'toggle-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'T'], 'Defx -no-toggle', 'show-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'o'], 'call call('
          \ . string(s:_function('s:defx_find_current_file')) . ', [])',
          \ 'open-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 't'], 'exe "Defx -no-toggle " . fnameescape(expand("%:p:h"))', 'show-file-tree-at-buffer-dir', 1)
  elseif g:spacevim_filemanager ==# 'nvim-tree'
    call SpaceVim#mapping#space#def('nnoremap', ['f', 't'], 'NvimTreeToggle', 'toggle-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'T'], 'NvimTree', 'show-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'o'], "NvimTreeFindFile", 'open-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 't'], 'exe "NvimTreeOpen " . fnameescape(expand("%:p:h"))', 'show-file-tree-at-buffer-dir', 1)
  elseif g:spacevim_filemanager ==# 'neo-tree'
    call SpaceVim#mapping#space#def('nnoremap', ['f', 't'], 'NeoTreeFocusToggle', 'toggle-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'T'], 'NeoTreeShow', 'show-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'o'], "Neotree reveal", 'open-file-tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 't'], 'Neotree dir=%:p:h', 'show-file-tree-at-buffer-dir', 1)
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'y'], 'call SpaceVim#util#CopyToClipboard()', 'show-and-copy-buffer-filename', 1)
  nnoremap <silent> <Plug>YankGitRemoteURL :call SpaceVim#util#CopyToClipboard(2)<Cr>
  vnoremap <silent> <Plug>YankGitRemoteURL :<C-u>call SpaceVim#util#CopyToClipboard(3)<Cr>
  call SpaceVim#mapping#space#def('nmap', ['f', 'Y'], '<Plug>YankGitRemoteURL', 'yank-remote-url', 0, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'v', 'v'], 'let @+=g:spacevim_version | echo g:spacevim_version', 'display-and-copy-version', 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'v', 'd'], 'SPConfig',
        \ ['open-custom-configuration',
        \ [
        \ '[SPC f v d] is to open the custom configuration file for SpaceVim',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  if has('nvim-0.10.0')
    let lnum = expand('<slnum>') + s:lnum - 1
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'v', 'l'], 'lua require("spacevim.plugin.logevents").toggle()',
          \ ['toggle-log-events',
          \ [
          \ '[SPC f v l] is to toggle log autocmd events. requires neovim 0.10.0+',
          \ '',
          \ 'Definition: ' . s:filename . ':' . lnum,
          \ ]
          \ ]
          \ , 1)
  endif
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['n', '-'], 'call call('
        \ . string(s:_function('s:number_transient_state')) . ', ["-"])',
        \ ['decrease-number-under-cursor',
        \ [
        \ '[SPC n -] is to decrease the number under the cursor, and open',
        \ 'the number translate state buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['n', '+'], 'call call('
        \ . string(s:_function('s:number_transient_state')) . ', ["+"])',
        \ ['increase-number-under-cursor',
        \ [
        \ '[SPC n +] is to increase the number under the cursor, and open',
        \ 'the number translate state buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  let g:vimproc#download_windows_dll = 1
  " call SpaceVim#mapping#space#def('nnoremap', ['p', 't'], 'call SpaceVim#plugins#projectmanager#current_root()', 'find-project-root', 1)
  let g:_spacevim_mappings_space.p.t = {'name' : '+Tasks'}
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['p', 't', 'e'],
        \ 'call SpaceVim#plugins#tasks#edit()',
        \ ['edit-project-task',
        \ ['[SPC p t e] is to edit the task configuration file of current project,',
        \ 'the default task file is `.SpaceVim.d/tasks.toml`',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum]
        \ ]
        \ , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', 't', 'l'], 'call SpaceVim#plugins#tasks#list()', 'list-tasks', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', 't', 'c'], 'call SpaceVim#plugins#runner#clear_tasks()', 'clear-tasks', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', 't', 'r'],
        \ 'call SpaceVim#plugins#runner#run_task(SpaceVim#plugins#tasks#get())', 'pick-task-to-run', 1)
  " SPC p t f is defined in fuzzy finder layer
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'k'], 'call SpaceVim#plugins#projectmanager#kill_project()', 'kill-all-project-buffers', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'p'], 'call SpaceVim#plugins#projectmanager#list()', 'list-all-projects', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', '/'], 'Grepper', 'fuzzy search for text in current project', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['q', 'q'], 'qa', 'prompt-kill-vim', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['q', 'Q'], 'qa!', 'kill-vim', 1)
  if has('nvim') && s:SYS.isWindows
    call SpaceVim#mapping#space#def('nnoremap', ['q', 'R'], 'call call('
          \ . string(s:_function('s:restart_neovim_qt')) . ', [])',
          \ 'restrat-neovim-qt', 1)
  else
    call SpaceVim#mapping#space#def('nnoremap', ['q', 'R'], '', 'restart-vim(TODO)', 1)
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['q', 'r'], '', 'restart-vim-resume-layouts(TODO)', 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['q', 't'], 'call call('
        \ . string(s:_function('s:close_current_tab')) . ', [])',
        \ ['close-current-tab',
        \ [
        \ '[SPC q t] is to close the current tab, if it is the last tab, do nothing.',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  call SpaceVim#mapping#gd#add('HelpDescribe', function('s:gotodef'))

  let g:_spacevim_mappings_space.c = {'name' : '+Comments'}
  "
  " Comments sections
  "
  " Toggles the comment state of the selected line(s). If the topmost selected
  " line is commented, all selected lines are uncommented and vice versa.
  nnoremap <silent> <Plug>CommentToLine :call <SID>comment_to_line(0)<Cr>
  nnoremap <silent> <Plug>CommenterInvertYank :call <SID>comment_invert_yank(0)<Cr>
  vnoremap <silent> <Plug>CommenterInvertYank :call <SID>comment_invert_yank(1)<Cr>
  nnoremap <silent> <Plug>CommentToLineInvert :call <SID>comment_to_line(1)<Cr>
  nnoremap <silent> <Plug>CommentParagraphs :call <SID>comment_paragraphs(0)<Cr>
  nnoremap <silent> <Plug>CommentParagraphsInvert :call <SID>comment_paragraphs(1)<Cr>
  call SpaceVim#mapping#space#def('nmap', ['c', 'a'], '<Plug>NERDCommenterAltDelims', 'switch-to-alternative-delims', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'l'], '<Plug>NERDCommenterInvert', 'toggle-comment-lines', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'L'], '<Plug>NERDCommenterComment', 'comment-lines', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'u'], '<Plug>NERDCommenterUncomment', 'uncomment-lines', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'v'], '<Plug>NERDCommenterInvertgv', 'toggle-visual-comment-lines', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 's'], '<Plug>NERDCommenterSexy', 'comment-with-sexy-layout', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'y'], '<Plug>CommenterInvertYank', 'yank-and-toggle-comment', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'Y'], '<Plug>NERDCommenterYank', 'yank-and-comment', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', '$'], '<Plug>NERDCommenterToEOL', 'comment-from-cursor-to-end-of-line', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 't'], '<Plug>CommentToLineInvert', 'toggle-comment-until-line', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'T'], '<Plug>CommentToLine', 'comment-until-the-line', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'p'], '<Plug>CommentParagraphsInvert', 'toggle-comment-paragraphs', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'P'], '<Plug>CommentParagraphs', 'comment-paragraphs', 0, 1)

  nnoremap <silent> <Plug>CommentOperator :set opfunc=<SID>commentOperator<Cr>g@
  let g:_spacevim_mappings_space[';'] = ['call feedkeys("\<Plug>CommentOperator")', 'comment-operator']
  nmap <silent> [SPC]; <Plug>CommentOperator
endfunction

function! s:gotodef() abort
  let fname = get(b:, 'defind_file_name', '')
  if !empty(fname)
    close
    exe 'edit ' . fname[0]
    exe fname[1]
  endif
endfunction

function! s:number_transient_state(n) abort
  if a:n ==# '+'
    exe "normal! \<c-a>" 
  else
    exe "normal! \<c-x>" 
  endif
  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('Number Transient State')
  call state.defind_keys(
        \ {'layout' : 'vertical split',
        \  'left' : [{'key' : ['+','='],
        \             'desc' : 'increase number',
        \             'func' : '',
        \             'cmd' : "normal! \<c-a>",
        \             'exit' : 0,
        \            },
        \           ],
        \ 'right' : [{'key' : '-',
        \             'desc' : 'decrease number',
        \             'func' : '',
        \             'cmd' : "normal! \<c-x>",
        \             'exit' : 0,
        \            },
        \           ],
        \ }
        \ )
  call state.open()
endfunction

function! s:next_file() abort
  let dir = expand('%:p:h')
  let f = expand('%:t')
  let file = s:FILE.ls(dir, 1)
  if index(file, f) == -1
    call add(file,f)
  endif
  call sort(file)
  if len(file) != 1
    if index(file, f) == len(file) - 1
      exe 'e ' . dir . s:FILE.separator . file[0]
    else
      exe 'e ' . dir . s:FILE.separator . file[index(file, f) + 1]
    endif
  endif
endfunction

function! s:previous_file() abort
  let dir = expand('%:p:h')
  let f = expand('%:t')
  let file = s:FILE.ls(dir, 1)
  if index(file, f) == -1
    call add(file,f)
  endif
  call sort(file)
  if len(file) != 1
    if index(file, f) == 0
      exe 'e ' . dir . s:FILE.separator . file[-1]
    else
      exe 'e ' . dir . s:FILE.separator . file[index(file, f) - 1]
    endif
  endif
endfunction

function! s:next_window() abort
  try
    exe (winnr() + 1 ) . 'wincmd w'
  catch
    exe 1 . 'wincmd w'
  endtry
endfunction

function! s:previous_window() abort
  try
    if winnr() == 1
      exe winnr('$') . 'wincmd w'
    else
      exe (winnr() - 1 ) . 'wincmd w'
    endif
  catch
    exe winnr('$') . 'wincmd w'
  endtry
endfunction

let g:string_info = {
      \ 'vim' : {
      \ 'connect' : '.',
      \ 'line_prefix' : '\',
      \ },
      \ 'java' : {
      \ 'connect' : '+',
      \ 'line_prefix' : '',
      \ },
      \ 'perl' : {
      \ 'connect' : '.',
      \ 'line_prefix' : '\',
      \ },
      \ 'python' : {
      \ 'connect' : '+',
      \ 'line_prefix' : '\',
      \ 'quotes_hi' : ['pythonQuotes']
      \ },
      \ }

function! s:jump_last_change() abort
  let [bufnum, lnum, col, off] = getpos("'.")
  let [_, l, c, _] = getpos('.')
  if lnum !=# l && c != col && lnum !=# 0 && col !=# 0
    call setpos('.', [bufnum, lnum, col, off])
  else
    call s:NOTI.notify('no change position!', 'WarningMsg')
  endif
endfunction

function! s:split_string(newline) abort
  if s:HI.is_string(line('.'), col('.'))
    let save_cursor = getcurpos()
    let c = col('.')
    let sep = ''
    while c > 0
      if s:HI.is_string(line('.'), c)
        let c -= 1
      else
        if !empty(get(get(g:string_info, &filetype, {}), 'quotes_hi', []))
          let sep = getline('.')[c - 1]
        else
          let sep = getline('.')[c]
        endif
        break
      endif
    endwhile
    let addedtext = a:newline ? "\n" . get(get(g:string_info, &filetype, {}), 'line_prefix', '') : ''
    let connect = get(get(g:string_info, &filetype, {}), 'connect', '')
    if !empty(connect)
      let connect = ' ' . connect . ' '
    endif
    if a:newline
      let addedtext = addedtext . connect
    else
      let addedtext = connect
    endif
    let save_register_m = @m
    let @m = sep . addedtext . sep
    normal! "mp
    let @m = save_register_m
    if a:newline
      normal! j==
    endif
    call setpos('.', save_cursor)
  endif
endfunction

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif

function! s:safe_erase_buffer() abort
  if s:MESSAGE.confirm('Erase content of buffer ' . expand('%:t'))
    normal! ggdG
  else
    echo 'canceled!'
  endif
endfunction

function! s:ToggleWinDiskManager() abort
  if bufexists('__windisk__')
    execute 'bd "__windisk__"'
  else
    call SpaceVim#plugins#windisk#open()
  endif
endfunction

function! s:open_message_buffer() abort
  edit __Message_Buffer__
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonumber norelativenumber
  setf SpaceVimMessageBuffer
  setlocal modifiable
  noautocmd normal! gg"_dG
  silent put=s:CMP.execute(':message')
  normal! G
  setlocal nomodifiable
  nnoremap <buffer><silent> q :call <SID>close_message_buffer()<CR>
endfunction

function! s:only_buf_win() abort
  only
  call SpaceVim#mapping#clear_saved_buffers()
endfunction

function! s:close_message_buffer() abort
  try
    bp
  catch /^Vim\%((\a\+)\)\=:E85/
    bd
  endtry
endfunction

function! s:safe_revert_buffer() abort
  if s:MESSAGE.confirm('Revert buffer form ' . expand('%:p'))
    edit!
  else
    echo 'canceled!'
  endif
  redraw!
endfunction

function! s:delete_current_buffer_file() abort
  if s:MESSAGE.confirm('Are you sure you want to delete this file')
    let f = expand('%')
    if delete(f) == 0
      call SpaceVim#mapping#close_current_buffer('n')
      echo "File '" . f . "' successfully deleted!"
    else
      call s:MESSAGE.warn('Failed to delete file:' . f)
    endif
  endif
endfunction

function! s:swap_buffer_with_nth_win(nr) abort
  if a:nr <= winnr('$') && a:nr != winnr()
    let cb = bufnr('%')
    let tb = winbufnr(a:nr)
    if cb != tb
      exe a:nr . 'wincmd w'
      exe 'b' . cb
      wincmd p
      exe 'b' . tb
    endif
  endif
endfunction

function! s:move_buffer_to_nth_win(nr) abort
  if a:nr <= winnr('$') && a:nr != winnr()
    let cb = bufnr('%')
    bp
    exe a:nr . 'wincmd w'
    exe 'b' . cb
    wincmd p
  endif
endfunction

function! s:buffer_transient_state() abort
  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('Buffer Selection Transient State')
  call state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'left' : [
        \ {
        \ 'key' : {
        \ 'name' : 'C-1..C-9',
        \ 'pos' : [[1,4], [6,9]],
        \ 'handles' : [
        \ ["\<C-1>" , ''],
        \ ["\<C-2>" , ''],
        \ ["\<C-3>" , ''],
        \ ["\<C-4>" , ''],
        \ ["\<C-5>" , ''],
        \ ["\<C-6>" , ''],
        \ ["\<C-7>" , ''],
        \ ["\<C-8>" , ''],
        \ ["\<C-9>" , ''],
        \ ],
        \ },
        \ 'desc' : 'goto nth window',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : {
        \ 'name' : '1..9',
        \ 'pos' : [[1,2], [4,5]],
        \ 'handles' : [
        \ ['1' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [1])'],
        \ ['2' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [2])'],
        \ ['3' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [3])'],
        \ ['4' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [4])'],
        \ ['5' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [5])'],
        \ ['6' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [6])'],
        \ ['7' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [7])'],
        \ ['8' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [8])'],
        \ ['9' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [9])'],
        \ ],
        \ },
        \ 'desc' : 'move buffer to nth window',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : {
        \ 'name' : 'M-1..M-9',
        \ 'pos' : [[1,4], [6,9]],
        \ 'handles' : [
        \ ["\<M-1>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [1])'],
        \ ["\<M-2>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [2])'],
        \ ["\<M-3>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [3])'],
        \ ["\<M-4>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [4])'],
        \ ["\<M-5>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [5])'],
        \ ["\<M-6>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [6])'],
        \ ["\<M-7>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [7])'],
        \ ["\<M-8>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [8])'],
        \ ["\<M-9>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [9])'],
        \ ],
        \ },
        \ 'desc' : 'swap buffer with nth window',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ ],
        \ 'right' : [
        \ {
        \ 'key' : 'n',
        \ 'desc' : 'next buffer',
        \ 'func' : '',
        \ 'cmd' : 'bnext',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : ['N', 'p'],
        \ 'desc' : 'previous buffer',
        \ 'func' : '',
        \ 'cmd' : 'bp',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'd',
        \ 'desc' : 'kill buffer',
        \ 'func' : '',
        \ 'cmd' : 'call SpaceVim#mapping#close_current_buffer()',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'q',
        \ 'desc' : 'quit',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 1,
        \ },
        \ ],
        \ }
        \ )
  call state.open()
endfunction

function! s:commentOperator(type, ...) abort
  let sel_save = &selection
  let &selection = 'inclusive'
  let reg_save = @@

  if a:0  " Invoked from Visual mode, use gv command.
    silent exe 'normal! gv'
    call feedkeys("\<Plug>NERDCommenterComment")
  elseif a:type ==# 'line'
    call feedkeys('`[V`]')
    call feedkeys("\<Plug>NERDCommenterComment")
  else
    call feedkeys('`[v`]')
    call feedkeys("\<Plug>NERDCommenterComment")
  endif

  let &selection = sel_save
  let @@ = reg_save
  set opfunc=
endfunction

function! s:comment_to_line(invert) abort
  let input = input('line number: ')
  if empty(input)
    return
  endif
  let line = str2nr(input)
  let ex = line - line('.')
  if ex > 0
    exe 'normal! V'. ex .'j'
  elseif ex == 0
  else
    exe 'normal! V'. abs(ex) .'k'
  endif
  if a:invert
    call feedkeys("\<Plug>NERDCommenterInvert")
  else
    call feedkeys("\<Plug>NERDCommenterComment")
  endif
endfunction

function! s:comment_invert_yank(visual) range abort
  if a:visual
    normal! gvy
    normal! gv
  else
    normal! yy
  endif
  call feedkeys("\<Plug>NERDCommenterInvert")
endfunction


function! s:comment_paragraphs(invert) abort
  if a:invert
    call feedkeys("vip\<Plug>NERDCommenterInvert")
  else
    call feedkeys("vip\<Plug>NERDCommenterComment")
  endif
endfunction

" this func only for neovim-qt in windows
function! s:restart_neovim_qt() abort
  call system('taskkill /f /t /im nvim.exe')
endfunction

function! s:jump_transient_state() abort
  let state = SpaceVim#api#import('transient_state')
  call state.set_title('Jump Transient State')
  call state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'left' : [
        \ {
        \ 'key' : 'j',
        \ 'desc' : 'next jump',
        \ 'func' : '',
        \ 'cmd' : 'try | exe "norm! \<C-i>"| catch | endtry ',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'J',
        \ 'desc' : 'previous jump',
        \ 'func' : '',
        \ 'cmd' : 'try | exe "norm! \<c-o>" | catch | endtry',
        \ 'exit' : 0,
        \ },
        \ ],
        \ 'right' : [
        \ {
        \ 'key' : 'c',
        \ 'desc' : 'next change',
        \ 'func' : '',
        \ 'cmd' : "try | exe 'norm! g,' | catch | endtry",
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'C',
        \ 'desc' : 'previous change',
        \ 'func' : '',
        \ 'cmd' : "try | exe 'norm! g;' | catch | endtry",
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'q',
        \ 'desc' : 'quit',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 1,
        \ },
        \ ],
        \ }
        \ )
  call state.open()
endfunction

function! s:save_current_file() abort
  let v:errmsg = ''
  silent! write
  if v:errmsg !=# ''
    echohl ErrorMsg
    echo  v:errmsg
    echohl None
  else
    echohl Delimiter
    echo  fnamemodify(bufname(), ':.:gs?[\\/]?/?') . ' written'
    echohl None
  endif
endfunction


" the `SPC f a` key binding cause many erros:
" E212: Can't open file for writing: no such file or directory
" E216: No such group or event: FileExplorer
"
" Fix E216: No such group or event: FileExplorer
" which is called in bundle/nerdtree/plugin/NERD_tree.vim:184
augroup FileExplorer
  autocmd!
augroup END


function! s:rename_current_file() abort
  let current_fname = bufname()
  if empty(current_fname)
    echo 'can not rename empty filename!'
    return
  endif
  let input = input('Rename to: ', fnamemodify(current_fname, ':p'), 'file')
  noautocmd normal! :
  if !empty(input)
    exe 'silent! file ' . input
    exe 'silent! w '
    call delete(current_fname)
    if v:errmsg !=# ''
      echohl ErrorMsg
      echo  v:errmsg
      echohl None
    else
      echohl Delimiter
      echo  fnamemodify(bufname(), ':.:gs?[\\/]?/?') . ' Renamed'
      echohl None
    endif
  else
    echo 'canceled!'
  endif


endfunction

function! s:save_as_new_file() abort
  let current_fname = bufname()
  if !empty(current_fname)
    let dir = fnamemodify(current_fname, ':h') . s:FILE.separator
  else
    let dir = getcwd() . s:FILE.separator
  endif
  let input = input('save as: ', dir, 'file')
  " clear cmdline
  noautocmd normal! :
  if !empty(input)
    exe 'silent! write ' . input
    exe 'e ' . input
    if v:errmsg !=# ''
      echohl ErrorMsg
      echo  v:errmsg
      echohl None
    else
      echohl Delimiter
      echo  fnamemodify(bufname(), ':.:gs?[\\/]?/?') . ' written'
      echohl None
    endif
  else
    echo 'canceled!'
  endif

endfunction

let g:_spacevim_autoclose_filetree = 1
function! s:explore_current_dir(cur) abort
  if g:spacevim_filemanager ==# 'vimfiler'
    if !a:cur
      let g:_spacevim_autoclose_filetree = 0
      VimFilerCurrentDir -no-split -no-toggle
      let g:_spacevim_autoclose_filetree = 1
    else
      VimFilerCurrentDir -no-toggle
    endif
  elseif g:spacevim_filemanager ==# 'nerdtree'
    if !a:cur
      exe 'e ' . getcwd() 
    else
      NERDTreeCWD
    endif
  elseif g:spacevim_filemanager ==# 'defx'
    if !a:cur
      let g:_spacevim_autoclose_filetree = 0
      Defx -no-toggle -no-resume -split=no `getcwd()`
      let g:_spacevim_autoclose_filetree = 1
    else
      Defx -no-toggle
    endif
  endif
endfunction


let g:_spacevim_filetree_show_hidden_files = 0
let g:_spacevim_filetree_opened_icon = '▼'
let g:_spacevim_filetree_closed_icon = '▶'

function! SpaceVim#layers#core#set_variable(var) abort

  let g:_spacevim_filetree_show_hidden_files = get(a:var,
        \ 'filetree_show_hidden',
        \ g:_spacevim_filetree_show_hidden_files)
  let g:_spacevim_filetree_opened_icon = get(a:var,
        \ 'filetree_opened_icon',
        \ g:_spacevim_filetree_opened_icon)
  let g:_spacevim_filetree_closed_icon = get(a:var,
        \ 'filetree_closed_icon',
        \ g:_spacevim_filetree_closed_icon)
  let s:enable_smooth_scrolling = get(a:var,
        \ 'enable_smooth_scrolling',
        \ s:enable_smooth_scrolling)
  let g:smoothie_no_default_mappings = !s:enable_smooth_scrolling
  let g:_spacevim_enable_filetree_filetypeicon = get(a:var,
        \ 'enable_filetree_filetypeicon',
        \ g:_spacevim_enable_filetree_filetypeicon)
  let g:_spacevim_enable_filetree_gitstatus = get(a:var,
        \ 'enable_filetree_gitstatus',
        \ g:_spacevim_enable_filetree_gitstatus)
  let s:enable_netrw = get(a:var,
        \ 'enable_netrw',
        \ 0)
  let s:enable_quickfix_key_bindings = get(a:var,
        \ 'enable_quickfix_key_bindings',
        \ s:enable_quickfix_key_bindings)
  let s:enable_winbar = get(a:var,
        \ 'enable_winbar',
        \ s:enable_winbar)
endfunction

function! s:defx_find_current_file() abort
  let current_file = s:FILE.unify_path(expand('%'), ':p')
  let current_dir  = s:FILE.unify_path(getcwd())

  let command = "Defx  -no-toggle -search=`expand('%:p')` "
  if stridx(current_file, current_dir) < 0
    let command .= expand('%:p:h')
  else
    let command .= getcwd()
  endif

  call execute(command)

endfunction

function! SpaceVim#layers#core#get_options() abort

  return [
        \ 'filetree_closed_icon',
        \ 'filetree_opened_icon',
        \ 'filetree_show_hidden',
        \ 'enable_smooth_scrolling',
        \ 'enable_filetree_filetypeicon'
        \ ]

endfunction

function! SpaceVim#layers#core#health() abort
  call SpaceVim#layers#core#plugins()
  call SpaceVim#layers#core#config()
  return 1
endfunction

function! s:close_current_tab() abort
  if tabpagenr('$') > 1
    tabclose!
  endif
endfunction

function! SpaceVim#layers#core#loadable() abort

  return 1

endfunction

" vim:set et sw=2 cc=80:
