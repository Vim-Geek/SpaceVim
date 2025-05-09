"=============================================================================
" colorscheme.vim --- SpaceVim colorscheme layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section colorscheme, layers-colorscheme
" @parentsection layers
" The default colorscheme of SpaceVim is gruvbox. It can be changed via
" `colorscheme` option by adding the following code to @section(options) file:
" >
" [options]
"   colorscheme = 'solarized'
" <
"
" The following colorschemes are include in SpaceVim. If the colorscheme you
" want is not included in the list below, a PR is welcome.
" >
"   | Name         | dark | light | term | gui | statusline |
"   | ------------ | ---- | ----- | ---- | --- | ---------- |
"   | molokai      | yes  | no    | yes  | yes | yes        |
"   | srcery       | yes  | no    | yes  | yes | yes        |
"   | onedark      | yes  | no    | yes  | yes | yes        |
"   | jellybeans   | yes  | no    | yes  | yes | yes        |
"   | palenight    | yes  | no    | yes  | yes | yes        |
"   | one          | yes  | yes   | yes  | yes | yes        |
"   | nord         | yes  | no    | yes  | yes | yes        |
"   | gruvbox      | yes  | yes   | yes  | yes | yes        |
"   | NeoSolarized | yes  | yes   | yes  | yes | yes        |
"   | hybrid       | yes  | yes   | yes  | yes | yes        |
"   | material     | yes  | yes   | yes  | yes | yes        |
"   | dracula      | yes  | yes   | yes  | yes | yes        |
"   | SpaceVim     | yes  | yes   | yes  | yes | yes        |
" <
" Also, there's one thing which everyone should know and pay attention to.
" NOT all of above colorschemes support spell check very well. For example,
" a colorscheme called atom doesn't support spell check very well.
"
" SpaceVim is not gonna fix them since these should be in charge of each author.

if exists('s:JSON')
  finish
endif

let s:JSON = SpaceVim#api#import('data#json')

function! SpaceVim#layers#colorscheme#plugins() abort


        " \ ['icymind/NeoSolarized', { 'merged' : 0 }],
  let plugins = [
        \ ['Gabirel/molokai', { 'merged' : 0 }],
        \ ['joshdick/onedark.vim', { 'merged' : 0 }],
        \ ['nanotech/jellybeans.vim', { 'merged' : 0 }],
        \ ['arcticicestudio/nord-vim', { 'merged' : 0 }],
        \ ['Tsuzat/NeoSolarized.nvim', { 'merged' : 0 }],
        \ ['SpaceVim/vim-material', { 'merged' : 0}],
        \ ['srcery-colors/srcery-vim', { 'merged' : 0}],
        \ [ 'drewtempelmeyer/palenight.vim', {'merged': 0 }],
        \ ]
  call add(plugins, [g:_spacevim_root_dir . 'bundle/dracula', {'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-one', {'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-hybrid', {'merged' : 0}])
  "
  " TODO:
  " \ ['mhartington/oceanic-next', { 'merged' : 0 }],
  " \ ['junegunn/seoul256.vim', { 'merged' : 0 }],
  " \ ['kabbamine/yowish.vim', { 'merged' : 0 }],
  " \ ['KeitaNakamura/neodark.vim', { 'merged' : 0 }],
  " \ ['NLKNguyen/papercolor-theme', { 'merged' : 0 }],
  " \ ['SpaceVim/FlatColor', { 'merged' : 0 }],
  return plugins
endfunction

let s:cs = [
      \ 'gruvbox',
      \ 'molokai',
      \ 'onedark',
      \ 'jellybeans',
      \ 'one',
      \ 'nord',
      \ 'hybrid',
      \ 'NeoSolarized',
      \ 'material',
      \ 'srcery',
      \ ]
let s:NUMBER = SpaceVim#api#import('data#number')

let s:time = {
      \ 'everytime' : 1,
      \ 'daily' : 1 * 24 * 60 * 60 * 1000,
      \ 'hourly' : 1 * 60 * 60 * 1000,
      \ 'weekly' : 7 * 24 * 60 * 60 * 1000,
      \ }

for s:n in range(1, 23)
  call extend(s:time, {s:n . 'h' : s:n * 60 * 60 * 1000})
endfor

unlet s:n

let s:random_colorscheme = 0
let s:random_candidates = s:cs
let s:random_frequency = ''
let s:bright_statusline = 0

function! SpaceVim#layers#colorscheme#config() abort
  if s:random_colorscheme
    let ctime = ''
    " Use local file's save time, the local file is
    " ~/.cache/SpaceVim/colorscheme_frequency.json
    " {"frequency" : "dalily", "last" : 000000, 'theme' : 'one'}
    " FIXME: when global config cache is updated, check the cache also should
    " be updated
    if filereadable(expand(g:spacevim_data_dir.'SpaceVim/colorscheme_frequency.json'))
      let conf = s:JSON.json_decode(join(readfile(expand(g:spacevim_data_dir.'SpaceVim/colorscheme_frequency.json'), ''), ''))
      if s:random_frequency !=# '' && !empty(conf)
        let ctime = localtime()
        if index(s:random_candidates, get(conf, 'theme', '')) == -1 ||
              \ ctime - get(conf, 'last', 0) >= get(s:time,  get(conf, 'frequency', ''), 0)
          let id = s:NUMBER.random(0, len(s:random_candidates))
          let g:spacevim_colorscheme = s:random_candidates[id]
          call s:update_conf()
        else
          let g:spacevim_colorscheme = conf.theme
        endif
      else
        let id = s:NUMBER.random(0, len(s:random_candidates))
        let g:spacevim_colorscheme = s:random_candidates[id]
      endif
    else
      if s:random_frequency !=# ''
        call s:update_conf()
      endif
    endif
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['T', 'n'],
        \ 'call call(' . string(s:_function('s:cycle_spacevim_theme'))
        \ . ', [])', 'cycle-spacevim-theme', 1)
endfunction

function! s:update_conf() abort
  let conf = {
        \ 'frequency' : s:random_frequency,
        \ 'last' : localtime(),
        \ 'theme' : g:spacevim_colorscheme
        \ }
  call writefile([s:JSON.json_encode(conf)], expand(g:spacevim_data_dir.'SpaceVim/colorscheme_frequency.json'))
endfunction


function! SpaceVim#layers#colorscheme#set_variable(var) abort
  let s:random_colorscheme = get(a:var, 'random_theme', get(a:var, 'random-theme', 0))
  let s:random_candidates = get(a:var, 'random_candidates', get(a:var, 'random-candidates', s:cs))
  let s:random_frequency = get(a:var, 'frequency', 'hourly')
  let s:bright_statusline = get(a:var, 'bright_statusline', 0)
endfunction

function! SpaceVim#layers#colorscheme#get_variable() abort
  return s:
endfunction

function! SpaceVim#layers#colorscheme#get_options() abort

  return ['random_theme']

endfunction

function! SpaceVim#layers#colorscheme#health() abort
  call SpaceVim#layers#colorscheme#plugins()
  call SpaceVim#layers#colorscheme#config()
  return 1
endfunction

function! SpaceVim#layers#colorscheme#loadable() abort

  return 1

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
function! s:cycle_spacevim_theme() abort
  let id = s:NUMBER.random(0, len(s:cs))
  " if the frequency is not empty and random_theme is on, SPC T n should
  " update the cache file:
  let g:spacevim_colorscheme = s:cs[id]
  exe 'colorscheme ' . g:spacevim_colorscheme
  call s:update_conf()
endfunction
