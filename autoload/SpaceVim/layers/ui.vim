"=============================================================================
" ui.vim --- SpaceVim ui layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

""
" @section ui, layers-ui
" @parentsection layers
" The `ui` layer defines the default interface for SpaceVim,
" and it is loaded by default.
" This layer includes scrollbar, indentline, and cursorword highlighting.
" >
"   [[layers]]
"     name = 'ui'
"     enable_sidebar = false
"     enable_scrollbar = false
"     enable_indentline = true
"     enable_cursorword = false
"     indentline_char = '|'
"     conceallevel = 0
"     concealcursor = ''
"     cursorword_delay = 50
"     cursorword_exclude_filetype = []
"     indentline_exclude_filetype = []
" <
"
" if you want to disable `ui` layer, you can use:
" >
"   [[layers]]
"     name = 'ui'
"     enabled = fasle
" <
" @subsection options
"
" 1. `enable_sidebar`: Enable/disable sidebar.
" 2. `enable_scrollbar`: Enable/disable floating scrollbar of current buffer.
" Disabled by default. This feature requires neovim's floating window.
" 3. `enable_indentline`: Enable/disable indentline of current buffer.
" Enabled by default.
" 4. `enable_cursorword`: Enable/disable  cursorword highlighting.
" Disabled by default.
" 5. `indentline_char`: Set the character of indentline.
" 6. `conceallevel`: set the conceallevel option.
" 7. `concealcursor`: set the concealcursor option.
" 8. `cursorword_delay`: The delay duration in milliseconds for setting the
" word highlight after cursor motions, the default is 50.
" 9. `cursorword_exclude_filetypes`: Ignore filetypes when enable cursorword
" highlighting.
" 10. `indentline_exclude_filetype`: Ignore filetypes when enable indentline.
"
" @subsection key bindings
" >
"   Key binding     Description
"   SPC t h         ui current buffer or selection lines
" <
"


if exists('s:enable_sidebar')
  finish
else
  let s:enable_sidebar = 0
  let s:enable_scrollbar = 0
  let s:enable_indentline = v:true
  let s:indentline_char = '|'
  let s:indentline_exclude_filetype = []
  let s:enable_cursorword = 0
  let s:conceallevel = 0
  let s:concealcursor = ''
  let s:cursorword_delay = 50
  let s:cursorword_exclude_filetypes = []
endif

let s:NVIM_VERSION = SpaceVim#api#import('neovim#version')

function! SpaceVim#layers#ui#plugins() abort
  let plugins = [
        \ [g:_spacevim_root_dir . 'bundle/vim-cursorword', {'merged' : 0, 'on_event' : ['CursorMoved', 'CursorMovedI']}],
        \ [g:_spacevim_root_dir . 'bundle/tagbar',
        \ {'loadconf' : 1, 'merged' : 0, 'on_cmd' : ['TagbarToggle', 'Tagbar']}],
        \ [g:_spacevim_root_dir . 'bundle/tagbar-makefile.vim',
        \ {'merged': 0}],
        \ [g:_spacevim_root_dir . 'bundle/tagbar-proto.vim', {'merged': 0}],
        \ [g:_spacevim_root_dir . 'bundle/vim-startify',
        \ {'loadconf' : 1, 'merged' : 0}],
        \ [g:_spacevim_root_dir . 'bundle/vim-better-whitespace',
        \ { 'on_cmd' : [
          \ 'StripWhitespace',
          \ 'ToggleWhitespace',
          \ 'DisableWhitespace',
          \ 'EnableWhitespace'
          \ ]}],
          \ ]
  call add(plugins, [g:_spacevim_root_dir . 'bundle/neomru.vim', {'merged' : 0}])
  if (has('nvim-0.5.0') && s:NVIM_VERSION.is_release_version())
        \ || has('nvim-0.6.0')
    " call add(plugins, [g:_spacevim_root_dir . 'bundle/indent-blankline.nvim',
          " \ { 'merged' : 0, 'on_event' : ['BufReadPost']}])
  else
    call add(plugins, [g:_spacevim_root_dir . 'bundle/indentLine',
          \ { 'merged' : 0}])
  endif
  if !SpaceVim#layers#isLoaded('core#statusline')
    " call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-airline',
          " \ { 'merged' : 0,
          " \ 'loadconf' : 1}])
    " call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-airline-themes',
          " \ { 'merged' : 0}])
  endif
  if s:enable_scrollbar
    call add(plugins, [g:_spacevim_root_dir . 'bundle/scrollbar.vim',
          \ { 'merged' : 0}])
  endif

  return plugins

endfunction

let s:file = expand('<sfile>:~')
let s:funcbeginline =  expand('<slnum>') + 1
function! SpaceVim#layers#ui#config() abort
  if g:spacevim_colorscheme_bg ==# 'dark'
    let g:indentLine_color_term = get(g:, 'indentLine_color_term', 239)
    let g:indentLine_color_gui = get(g:, 'indentLine_color_gui', '#504945')
  else
    let g:indentLine_color_gui = get(g:, 'indentLine_color_gui', '#d5c4a1')
  endif

  " indent line configuration
  " indent_blankline for neovim, indentLine for vim and old neovim

  " indent line character
  let g:indent_blankline_char = s:indentline_char
  let g:indentLine_char = s:indentline_char

  " indent line conceal setting, only for indentLine
  let g:indentLine_concealcursor = s:concealcursor
  let g:indentLine_conceallevel = s:conceallevel

  " enable/disable indentline
  let g:indentLine_enabled = s:enable_indentline
  " indent_blankline config
  " let g:indent_blankline_enabled = s:enable_indentline ? v:true : v:false
  " this var must be boolean, but v:true is added in vim 7.4.1154
  let g:indent_blankline_enabled =
        \ s:enable_indentline ?
        \ get(v:, 'true', 1)
        \ :
        \ get(v:, 'false', 0)

  " exclude filetypes for indentline
  let g:indentLine_fileTypeExclude = s:indentline_exclude_filetype

  let g:indent_blankline_filetype_exclude = s:indentline_exclude_filetype
        \ + ['startify', 'gitcommit', 'defx']

  " option for better-whitespace
  let g:better_whitespace_filetypes_blacklist = ['diff', 'gitcommit', 'unite',
        \ 'qf', 'help', 'markdown', 'leaderGuide',
        \ 'startify'
        \ ]
  let g:signify_disable_by_default = 0
  let g:signify_line_highlight = 0
  let g:cursorword = s:enable_cursorword
  let g:cursorword_delay = s:cursorword_delay

  if s:enable_sidebar
    noremap <silent> <F2> :call SpaceVim#plugins#sidebar#toggle()<CR>
  else
    noremap <silent> <F2> :TagbarToggle<CR>
  endif

  augroup spacevim_layer_ui
    autocmd!
    if !empty(s:cursorword_exclude_filetypes)
      exe printf('autocmd FileType %s let b:cursorword = 0',
            \ join(s:cursorword_exclude_filetypes, ','))
    endif
  augroup end

  if !empty(g:spacevim_windows_smartclose)
    call SpaceVim#mapping#def('nnoremap <silent>',
          \ g:spacevim_windows_smartclose,
          \ ':<C-u>call SpaceVim#mapping#SmartClose()<cr>',
          \ 'smart-close-windows',
          \ 'call SpaceVim#mapping#SmartClose()')
  endif
  " Ui toggles
  call SpaceVim#mapping#space#def('nnoremap', ['t', '8'],
        \ 'call SpaceVim#layers#core#statusline#toggle_mode("hi-characters-for-long-lines")',
        \ 'highlight-long-lines', 1)
  if g:spacevim_autocomplete_method ==# 'deoplete'
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'a'], 'call SpaceVim#layers#autocomplete#toggle_deoplete()',
          \ 'toggle autocomplete', 1)
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'b'], 'call call('
        \ . string(s:_function('s:toggle_background')) . ', [])',
        \ 'toggle background', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', '.'], 'call call('
        \ . string(s:_function('s:win_resize_transient_state')) . ', [])',
        \ 'windows-transient-state', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'c'], 'call call('
        \ . string(s:_function('s:toggle_conceallevel')) . ', [])',
        \ 'toggle conceallevel', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 't'], 'call SpaceVim#plugins#tabmanager#open()',
        \ 'open-tabs-manager', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'f'], 'call SpaceVim#layers#core#statusline#toggle_mode("fill-column-indicator")',
        \ 'fill-column-indicator', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 'h'], 'call call('
        \ . string(s:_function('s:toggle_cursorline')) . ', [])',
        \ ['toggle-highlight-current-line',
        \ [
          \ 'SPC t h h is to toggle the highlighting of cursorline'
          \ ]
          \ ], 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 'i'], 'call call('
        \ . string(s:_function('s:toggle_indentline')) . ', [])',
        \ ['toggle-highlight-indentation-levels',
        \ [
          \ 'SPC t h i is to running :IndentLinesToggle which is definded in indentLine'
          \ ]
          \ ], 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 'c'], 'set cursorcolumn!',
        \ 'toggle-highlight-current-column', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 's'], 'call call('
        \ . string(s:_function('s:toggle_syntax_hi')) . ', [])',
        \ 'toggle-syntax-highlighting', 1)

  call SpaceVim#mapping#space#def('nnoremap', ['T', 'F'], 'call call('
        \ . string(s:_function('s:toggle_full_screen')) . ', [])',
        \ 'fullscreen-frame', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['T', 'm'], 'call call('
        \ . string(s:_function('s:toggle_menu_bar')) . ', [])',
        \ 'toggle-menu-bar', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['T', 'f'], 'call call('
        \ . string(s:_function('s:toggle_win_fringe')) . ', [])',
        \ 'toggle-win-fringe', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['T', 't'], 'call call('
        \ . string(s:_function('s:toggle_tool_bar')) . ', [])',
        \ 'toggle-tool-bar', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['T', '~'], 'call call('
        \ . string(s:_function('s:toggle_end_of_buffer')) . ', [])',
        \ 'display ~ in the fringe on empty lines', 1)
  call SpaceVim#layers#core#statusline#register_mode(
        \ {
          \ 'key' : 'spell-checking',
          \ 'func' : s:_function('s:toggle_spell_check'),
          \ }
          \ )
  call SpaceVim#layers#core#statusline#register_mode(
        \ {
          \ 'key' : 'hi-characters-for-long-lines',
          \ 'func' : s:_function('s:toggle_fill_column'),
          \ }
          \ )
  call SpaceVim#layers#core#statusline#register_mode(
        \ {
          \ 'key' : 'fill-column-indicator',
          \ 'func' : s:_function('s:toggle_colorcolumn'),
          \ }
          \ )
  call SpaceVim#layers#core#statusline#register_mode(
        \ {
          \ 'key' : 'whitespace',
          \ 'func' : s:_function('s:toggle_whitespace'),
          \ }
          \ )
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'w'],
        \ 'call SpaceVim#layers#core#statusline#toggle_mode("whitespace")',
        \ ['toggle-highlight-tail-spaces',
        \ [
          \ '[SPC t w] will toggle white space highlighting',
          \ '',
          \ 'Definition: ' . s:file . ':' . s:lnum,
          \ ]
          \ ]
          \ , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'S'],
        \ 'call SpaceVim#layers#core#statusline#toggle_mode("spell-checking")',
        \ 'toggle-spell-checker', 1)
  call SpaceVim#layers#core#statusline#register_mode(
        \ {
          \ 'key' : 'paste-mode',
          \ 'func' : s:_function('s:toggle_paste'),
          \ }
          \ )
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'p'],
        \ 'call SpaceVim#layers#core#statusline#toggle_mode("paste-mode")',
        \ 'toggle-paste-mode', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'P'],
        \ 'DelimitMateSwitch',
        \ 'toggle-auto-parens-mode', 1)

  call SpaceVim#mapping#space#def('nnoremap', ['t', 'l'], 'setlocal list!',
        \ 'toggle-hidden-listchars', 1)
  call SpaceVim#layers#core#statusline#register_mode(
        \ {
          \ 'key' : 'wrapline',
          \ 'func' : s:_function('s:toggle_wrap_line'),
          \ }
          \ )
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'W'],
        \ 'call SpaceVim#layers#core#statusline#toggle_mode("wrapline")',
        \ 'toggle-wrap-line', 1)

  nnoremap <silent> <F11> :call <SID>toggle_full_screen()<Cr>
  let g:_spacevim_mappings_space.z = get(g:_spacevim_mappings_space, 'z',  {'name' : '+Fonts'})
  call SpaceVim#mapping#space#def('nnoremap', ['z', '.'], 'call call('
        \ . string(s:_function('s:fonts_transient_state')) . ', [])',
        \ 'font-transient-state', 1)
endfunction

let s:fullscreen_flag = 0
function! s:toggle_full_screen() abort
  if has('nvim')
    if s:fullscreen_flag == 0
      call GuiWindowFullScreen(1)
      let s:fullscreen_flag = 1
    else
      call GuiWindowFullScreen(0)
      let s:fullscreen_flag = 0
    endif
  else
    " download gvimfullscreen.dll from github, copy gvimfullscreen.dll to
    " the directory that has gvim.exe
    call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)
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
let s:tmflag = 0
function! s:toggle_menu_bar() abort
  if !s:tmflag
    set go+=m
    let s:tmflag = 1
  else
    set go-=m
    let s:tmflag = 0
  endif
endfunction

let s:ttflag = 0
function! s:toggle_tool_bar() abort
  if !s:ttflag
    set go+=T
    let s:ttflag = 1
  else
    set go-=T
    let s:ttflag = 0
  endif
endfunction

if &cc ==# '80'
  let s:ccflag = 1
else
  let s:ccflag = 0
endif
function! s:toggle_colorcolumn() abort
  if !s:ccflag
    let &cc = g:spacevim_max_column
    let s:ccflag = 1
  else
    set cc=
    let s:ccflag = 0
  endif
  return 1
endfunction

let s:fcflag = 0
" use &textwidth option instead of 80
function! s:toggle_fill_column() abort
  if !s:fcflag
    if !&textwidth
      let &colorcolumn=join(range(81,999),',')
    else
      let &colorcolumn=join(range(&textwidth + 1,999),',')
    endif
    let s:fcflag = 1
  else
    set cc=
    let s:fcflag = 0
  endif
  return 1
endfunction

function! s:toggle_indentline() abort
  if exists(':IndentLinesToggle')
    IndentLinesToggle
  elseif exists(':IndentBlanklineToggle')
    IndentBlanklineToggle
  endif
endfunction

let s:shflag = 0
function! s:toggle_syntax_hi() abort
  if !s:shflag
    syntax off
    let s:shflag = 1
  else
    syntax on
    let s:shflag = 0
  endif
endfunction

let s:ebflag = 0
let s:HI = SpaceVim#api#import('vim#highlight')
function! s:toggle_end_of_buffer() abort
  if !s:ebflag
    if &background ==# 'dark'
      hi EndOfBuffer guifg=white
    else
      hi EndOfBuffer guifg=gray
    endif
    let s:ebflag = 1
  else
    if (exists('+termguicolors') && &termguicolors) || has('gui_running')
      let normalbg = s:HI.group2dict('Normal').guibg
    else
      let normalbg = s:HI.group2dict('Normal').ctermbg
    endif
    exe 'hi! EndOfBuffer guifg=' . normalbg . ' guibg=' . normalbg
    let s:ebflag = 0
  endif
endfunction

let s:tfflag = 0
function! s:toggle_win_fringe() abort
  if !s:tfflag
    set guioptions+=L
    set guioptions+=r
    let s:tfflag = 1
  else
    set guioptions-=L
    set guioptions-=r
    let s:tfflag = 0
  endif
endfunction

function! s:toggle_cursorline() abort
  setl cursorline!
  let g:_spacevim_cursorline_flag = g:_spacevim_cursorline_flag * -1
endfunction

function! s:toggle_spell_check() abort
  if &l:spell
    let &l:spell = 0
  else
    let v:errmsg = ''
    silent! let &l:spell = 1
  endif
  if v:errmsg !=# ''
    echo 'failed to enable spell check'
    silent! let &l:spell = 0
    return 0
  else
    if &l:spell == 1
      echo 'spell-checking enabled.'
    else
      echo 'spell-checking disabled.'
    endif
  endif
  return 1
endfunction

function! s:toggle_paste() abort
  if &l:paste
    let &l:paste = 0
  else
    let &l:paste = 1
  endif
  if &l:paste == 1
    echo 'paste-mode enabled.'
  else
    echo 'paste-mode disabled.'
  endif
  return 1
endfunction

let s:whitespace_enable = 0
function! s:toggle_whitespace() abort
  if s:whitespace_enable
    DisableWhitespace
    let s:whitespace_enable = 0
  else
    EnableWhitespace
    let s:whitespace_enable = 1
  endif
  call SpaceVim#layers#core#statusline#toggle_section('whitespace')
  return 1
endfunction

function! s:toggle_wrap_line() abort
  set wrap!
  return 1
endfunction

function! s:toggle_conceallevel() abort
  if &conceallevel == 0
    setlocal conceallevel=2
  else
    setlocal conceallevel=0
  endif
endfunction

function! s:toggle_background() abort
  let s:tbg = &background
  " Inversion
  if s:tbg ==# 'dark'
    set background=light
  else
    set background=dark
  endif
endfunction


function! s:win_resize_transient_state() abort
  let state = SpaceVim#api#import('transient_state')
  call state.set_title('Windows Resize Transient State')
  call state.defind_keys({
        \ 'layout' : 'vertical split',
        \ 'left' : [{
        \   'key' : 'H',
        \   'desc' : 'left',
        \   'func' : '',
        \   'cmd' : 'wincmd h',
        \   'exit' : 0,
        \ },{
        \   'key' : 'J',
        \   'desc' : 'below',
        \   'func' : '',
        \   'cmd' : 'wincmd j',
        \   'exit' : 0,
        \ },{
        \   'key' : 'K',
        \   'desc' : 'up',
        \   'func' : '',
        \   'cmd' : 'wincmd k',
        \   'exit' : 0,
        \ },{
        \   'key' : 'L',
        \   'desc' : 'right',
        \   'func' : '',
        \   'cmd' : 'wincmd l',
        \   'exit' : 0,
        \ },
        \ ],
        \ 'right' : [{
        \   'key' : 'h',
        \   'desc' : 'decrease width',
        \   'func' : '',
        \   'cmd' : 'vertical resize -1',
        \   'exit' : 0,
        \ },{
        \   'key' : 'l',
        \   'desc' : 'increase width',
        \   'func' : '',
        \   'cmd' : 'vertical resize +1',
        \   'exit' : 0,
        \ },{
        \   'key' : 'j',
        \   'desc' : 'decrease height',
        \   'func' : '',
        \   'cmd' : 'resize -1',
        \   'exit' : 0,
        \ },{
        \   'key' : 'k',
        \   'desc' : 'increase height',
        \   'func' : '',
        \   'cmd' : 'resize +1',
        \   'exit' : 0,
        \ },
        \ ],
        \ }
        \ )
  call state.open()
endfunction


function! SpaceVim#layers#ui#set_variable(var) abort

  let s:enable_sidebar = get(a:var,
        \ 'enable_sidebar',
        \ 0)
  let s:enable_scrollbar = get(a:var,
        \ 'enable_scrollbar',
        \ 0)
  let s:enable_indentline = get(a:var,
        \ 'enable_indentline',
        \ 1)
  let s:indentline_char = get(a:var,
        \ 'indentline_char',
        \ s:indentline_char)
  let s:indentline_exclude_filetype = get(a:var,
        \ 'indentline_exclude_filetype',
        \ s:indentline_exclude_filetype)
  let s:enable_cursorword = get(a:var,
        \ 'enable_cursorword',
        \ s:enable_cursorword)
  let s:conceallevel = get(a:var,
        \ 'conceallevel',
        \ s:conceallevel)
  let s:concealcursor = get(a:var,
        \ 'concealcursor',
        \ s:concealcursor)
  let s:cursorword_delay = get(a:var,
        \ 'cursorword_delay',
        \ s:cursorword_delay)
  " The old layer option is cursorword_exclude_filetype
  let s:cursorword_exclude_filetypes =
        \ get(a:var,
        \ 'cursorword_exclude_filetypes',
        \ get(a:var,
        \ 'cursorword_exclude_filetype',
        \ s:cursorword_exclude_filetypes
        \ ))
endfunction

function! SpaceVim#layers#ui#health() abort
  call SpaceVim#layers#ui#plugins()
  call SpaceVim#layers#ui#config()
  return 1
endfunction

function! SpaceVim#layers#ui#get_options() abort

  return ['enable_sidebar',
        \ 'enable_scrollbar',
        \ 'enable_indentline',
        \ 'enable_cursorword',
        \ 'cursorword_delay',
        \ 'concealcursor',
        \ 'conceallevel',
        \ 'indentline_exclude_filetype',
        \ 'indentline_char',
        \ 'cursorword_exclude_filetypes']

endfunction

function! s:fonts_transient_state() abort
  if !exists('s:guifont')
    let s:guifont = &guifont
  endif
  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('Fonts Transient State')
  call state.defind_keys({
        \ 'layout' : 'vertical split',
        \ 'left' : [{
        \   'key' : '+',
        \   'desc' : 'increase the font',
        \   'func' : '',
        \   'exit' : 0,
        \   'cmd' : 'call call(' . string(s:_function('s:increase_font')) . ', [])',
        \ },{
        \   'key' : '0',
        \   'desc' : 'reset the font size',
        \   'func' : '',
        \   'exit' : 0,
        \   'cmd' : 'call call(' . string(s:_function('s:reset_font_size')) . ', [])',
        \ },
        \ ],
        \ 'right' : [{
        \   'key' : '-',
        \   'desc' : 'reduce the font',
        \   'func' : '',
        \   'exit' : 0,
        \   'cmd' : 'call call(' . string(s:_function('s:reduce_font')) . ', [])',
        \ },
        \ ],
        \ }
        \ )
  call state.open()
endfunction

function! s:reset_font_size() abort
  let &guifont = s:guifont
  sleep 100m
endfunction

function! s:increase_font() abort
  let font_size = str2nr(matchstr(matchstr(&guifont, ':h\d\+'), '\d\+'))
  let font_size += 1
  let &guifont = substitute(&guifont, ':h\d\+', ':h' . font_size, '')
  sleep 100m
endfunction

function! s:reduce_font() abort
  let font_size = str2nr(matchstr(matchstr(&guifont, ':h\d\+'), '\d\+'))
  let font_size -= 1
  let &guifont = substitute(&guifont, ':h\d\+', ':h' . font_size, '')
  sleep 100m
endfunction

function! SpaceVim#layers#ui#loadable() abort

  return 1

endfunction
