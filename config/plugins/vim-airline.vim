scriptencoding utf-8
" set laststatus=2
set noshowmode
set linespace=2

let g:airline_theme                              = 'dark'
let g:airline_solarized_bg                       = 'dark'
let g:airline_exclude_preview                    = 0
let g:airline_powerline_fonts = get(g:, 'spacevim_enable_powerline_fonts', 1)
let g:airline_detect_modified                    = 1
let g:airline_detect_paste                       = 1
let g:airline_detect_crypt                       = 1
let g:airline_detect_spell                       = 1
let g:airline_detect_spelllang                   = 1
let g:airline_detect_iminsert                    = 1
let g:airline_highlighting_cache                 = 1

let g:airline_filetype_overrides = {
      \ 'coc-explorer':  [ 'CoC Explorer', '' ],
      \ 'defx':  ['defx', '%{b:defx.paths[0]}'],
      \ 'fugitive': ['fugitive', '%{airline#util#wrap(airline#extensions#branch#get_head(),80)}'],
      \ 'floggraph':  [ 'Flog', '%{get(b:, "flog_status_summary", "")}' ],
      \ 'gundo': [ 'Gundo', '' ],
      \ 'help':  [ 'Help', '%f' ],
      \ 'minibufexpl': [ 'MiniBufExplorer', '' ],
      \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', 'NERD'), '' ],
      \ 'startify': [ 'startify', '' ],
      \ 'vim-plug': [ 'Plugins', '' ],
      \ 'vimfiler': [ 'vimfiler', '%{vimfiler#get_status_string()}' ],
      \ 'vimshell': ['vimshell','%{vimshell#get_status_string()}'],
      \ 'vaffle' : [ 'Vaffle', '%{b:vaffle.dir' ],
      \ }

let g:airline_skip_empty_sections = 1
let g:Powerline_sybols = 'unicode'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ' '
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ' '

" powerline symbols
if get(g:, 'airline_powerline_fonts', 1)
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
" let g:airline_symbols.colnr = ' ℅:'
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.crypto = '󱀰'
  let g:airline_symbols.linenr = ' :'
  let g:airline_symbols.maxlinenr = ''
  let g:airline_symbols.dirty=' ⚡'
  let g:airline_symbols.spell='󰓆'
" let g:airline_symbols.space='⚡'
endif

if get(g:, 'spacevim_enable_os_fileformat_icon', 0)
  let s:sys = SpaceVim#api#import('system')
  let g:airline_section_y = " %{&fenc . ' ' . SpaceVim#api#import('system').fileformat()} "
endif

" call SpaceVim#mapping#def('nmap', '<leader>1', '<Plug>AirlineSelectTab1', 'Switch to airline tab 1', '', 'window 1')
" call SpaceVim#mapping#def('nmap', '<leader>2', '<Plug>AirlineSelectTab2', 'Switch to airline tab 2', '', 'window 2')
" call SpaceVim#mapping#def('nmap', '<leader>3', '<Plug>AirlineSelectTab3', 'Switch to airline tab 3', '', 'window 3')
" call SpaceVim#mapping#def('nmap', '<leader>4', '<Plug>AirlineSelectTab4', 'Switch to airline tab 4', '', 'window 4')
" call SpaceVim#mapping#def('nmap', '<leader>5', '<Plug>AirlineSelectTab5', 'Switch to airline tab 5', '', 'window 5')
" call SpaceVim#mapping#def('nmap', '<leader>6', '<Plug>AirlineSelectTab6', 'Switch to airline tab 6', '', 'window 6')
" call SpaceVim#mapping#def('nmap', '<leader>7', '<Plug>AirlineSelectTab7', 'Switch to airline tab 7', '', 'window 7')
" call SpaceVim#mapping#def('nmap', '<leader>8', '<Plug>AirlineSelectTab8', 'Switch to airline tab 8', '', 'window 8')
" call SpaceVim#mapping#def('nmap', '<leader>9', '<Plug>AirlineSelectTab9', 'Switch to airline tab 9', '', 'window 9')
" call SpaceVim#mapping#def('nmap', '<leader>-', '<Plug>AirlineSelectPrevTab', 'Switch to previous airline tag', '', 'window previous')
" call SpaceVim#mapping#def('nmap', '<leader>+', '<Plug>AirlineSelectNextTab', 'Switch to next airline tag', '', 'window next')
" call SpaceVim#mapping#space#def('nmap', [1], '<Plug>AirlineSelectTab1', 'window 1', 0)
" call SpaceVim#mapping#space#def('nmap', [2], '<Plug>AirlineSelectTab2', 'window 2', 0)
" call SpaceVim#mapping#space#def('nmap', [3], '<Plug>AirlineSelectTab3', 'window 3', 0)
" call SpaceVim#mapping#space#def('nmap', [4], '<Plug>AirlineSelectTab4', 'window 4', 0)
" call SpaceVim#mapping#space#def('nmap', [5], '<Plug>AirlineSelectTab5', 'window 5', 0)
" call SpaceVim#mapping#space#def('nmap', [6], '<Plug>AirlineSelectTab6', 'window 6', 0)
" call SpaceVim#mapping#space#def('nmap', [7], '<Plug>AirlineSelectTab7', 'window 7', 0)
" call SpaceVim#mapping#space#def('nmap', [8], '<Plug>AirlineSelectTab8', 'window 8', 0)
" call SpaceVim#mapping#space#def('nmap', [9], '<Plug>AirlineSelectTab9', 'window 9', 0)
call SpaceVim#mapping#space#def('nmap', ['['], '<Plug>AirlineSelectPrevTab', ' window previous', 0)
call SpaceVim#mapping#space#def('nmap', [']'], '<Plug>AirlineSelectNextTab', ' window next', 0)

" Extensions
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c', ],
      \ [ 'x', 'y', 'z', 'error', 'warning', ]
      \ ]

let g:airline#extensions#searchcount#enabled     = 1

let g:airline#extensions#tmuxline#enabled        = 1

let g:airline#extensions#quickfix#quickfix_text  = 'Quickfix'
let g:airline#extensions#quickfix#location_text  = 'Location'

"let g:airline#extensions#bufferline#enabled      = 1
"
let g:airline#extensions#bookmark#enabled        = 0

let g:airline#extensions#branch#enabled          = 1
let g:airline#extensions#branch#empty_message    = ''
let g:airline#extensions#branch#format           = 1


let g:airline#extensions#csv#enabled             = 1
let g:airline#extensions#csv#column_display      = 'Name'

let g:airline#extensions#eclim#enabled           = 0

let g:airline#extensions#syntastic#enabled       = 0

let g:airline#extensions#tagbar#enabled          = 0

let g:airline#extensions#csv#enabled             = 1

let g:airline#extensions#wordcount#enabled       = 1

let g:airline#extensions#whitespace#enabled      = 0

let g:airline#extensions#ycm#enabled             = 0

let g:airline#extensions#xkblayout#enabled             = 0

let g:airline#extensions#virtualenv#enabled      = 1
let g:airline#extensions#keymap#enabled          = 1
let g:airline#extensions#fugitiveline#enabled    = 1

let g:airline#extensions#hunks#enabled           = 1
let g:airline#extensions#hunks#non_zero_only     = 0
let g:airline#extensions#hunks#hunk_symbols      = ['+', '~', '-']
let g:airline#extensions#hunks#coc_git           = 1


let g:airline#extensions#ale#enabled             = 0

let g:airline#extensions#nvim_typescript#enabled = 1

let g:airline#extensions#coc#enabled             = 1
let g:airline#extensions#coc#error_symbol        = ' '
let g:airline#extensions#coc#warning_symbol      = ' '
" let airline#extensions#coc#stl_format_err        = '%E{[%e(#%fe)]}'
" let airline#extensions#coc#stl_format_warn       = '%W{[%w(#%fw)]}'
let g:airline#extensions#coc#show_coc_status     = 1
let g:airline#extensions#coc#stl_format_err      = '%C(L%L)'
let g:airline#extensions#coc#stl_format_warn     = '%C(L%L)'

let g:airline#extensions#fzf#enabled             = 1
let g:airline#extensions#vista#enabled           = 1

let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'

let g:airline#extensions#searchcount#enabled           = 1
let g:airline#extensions#searchcount#show_search_term  = 1
let g:airline#extensions#searchcount#search_term_limit = 8

let g:airline#extensions#wordcount#enabled = 1
let g:airline#extensions#wordcount#filetypes = ['asciidoc', 'help', 'mail', 'markdown', 'rmd', 'nroff', 'org', 'plaintex', 'rst', 'tex', 'text']

" Extension - tabline
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s:'
let g:airline#extensions#tabline#buffers_label = 'BUFFERS'
let g:airline#extensions#tabline#enabled         = 1
let g:airline#extensions#tabline#exclude_preview = 1
let g:airline#extensions#tabline#fnamemod        = ':t'
let g:airline#extensions#tabline#fnamecollapse   = 1
let g:airline#extensions#tabline#fnametruncate   = 0
"let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#formatter       = 'spacevim'
let g:airline#extensions#tabline#left_sep        = ''
let g:airline#extensions#tabline#left_alt_sep    = ' '
let g:airline#extensions#tabline#show_buffers    = 1
let g:airline#extensions#tabline#show_tabs       = 1
let g:airline#extensions#tabline#show_tab_nr     = 1
let g:airline#extensions#tabline#show_tab_type   = 1
let g:airline#extensions#tabline#tabs_label      = 'TABS'
let g:airline#extensions#tabline#tab_nr_type     = 1

if get(g:, 'spacevim_buffer_index_type', 1) < 3
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  let g:airline#extensions#tabline#buffer_idx_format = {}
  for s:i in range(9)
    call extend(g:airline#extensions#tabline#buffer_idx_format,
          \ {s:i : SpaceVim#api#import('messletters').bubble_num(s:i,
          \ get(g:, 'spacevim_buffer_index_type', 1)). ' '})
  endfor
  unlet s:i
elseif g:spacevim_buffer_index_type == 3
  let g:airline#extensions#tabline#buffer_idx_mode = 1
elseif g:spacevim_buffer_index_type == 4
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  let g:airline#extensions#tabline#buffer_idx_format = {
        \ '0': '0 ',
        \ '1': '1 ',
        \ '2': '2 ',
        \ '3': '3 ',
        \ '4': '4 ',
        \ '5': '5 ',
        \ '6': '6 ',
        \ '7': '7 ',
        \ '8': '8 ',
        \ '9': '9 '
        \}

endif

" vim:set et sw=2:
