"=============================================================================
" fzf.vim --- fzf layer for SpaceVim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section fzf, layers-fzf
" @parentsection layers
" This layer provides fuzzy finder feature which is based on `fzf`.
" This layer is not loaded by default. To use this layer:
" >
"   [[layers]]
"     name = 'fzf'
" <
" @subsection Key bindings
"
" The following key bindings will be enabled when this layer is loaded:
" >
"   Key bindings      Description
"   SPC p f / Ctrl-p  search files in current directory
"   <Leader> f SPC    Fuzzy find menu:CustomKeyMaps
"   <Leader> f e      Fuzzy find register
"   <Leader> f h      Fuzzy find history/yank
"   <Leader> f j      Fuzzy find jump, change
"   <Leader> f l      Fuzzy find location list
"   <Leader> f m      Fuzzy find output messages
"   <Leader> f o      Fuzzy find functions
"   <Leader> f t      Fuzzy find tags
"   <Leader> f q      Fuzzy find quick fix
"   <Leader> f p      Fuzzy find bundle plugins
" <


let s:CMP = SpaceVim#api#import('vim#compatible')
let s:LIST = SpaceVim#api#import('data#list')
let s:SYS = SpaceVim#api#import('system')
let s:fuzzy_finder = v:false

function! SpaceVim#layers#fzf#health() abort
  call SpaceVim#layers#fzf#plugins()
  call SpaceVim#layers#fzf#config()
  return 1
endfunction

function! SpaceVim#layers#fzf#set_variable(var) abort
  let s:fuzzy_finder = get(a:var, 'fuzzy_finder', v:false)
endfunction

function! SpaceVim#layers#fzf#plugins() abort
  let plugins = []
  call add(plugins, ['junegunn/fzf',                    { 'merged' : 0 }])
  call add(plugins, ['junegunn/fzf.vim',                { 'merged' : 0 }])
  call add(plugins, ['Shougo/neoyank.vim',              { 'merged' : 0 }])
  call add(plugins, ['yuki-ycino/fzf-preview.vim',      { 'merged' : 0, 'rev' : 'release/rpc', 'if' : "has('macunix')" }])

  " call add(plugins, [g:_spacevim_root_dir . 'bundle/neomru.vim', {'merged' : 0}])
  call add(plugins, ['SpaceVim/fzf-neoyank',            { 'merged' : 0 }])
  return plugins
endfunction

let s:filename = expand('<sfile>:~')
function! SpaceVim#layers#fzf#config() abort
  augroup fzf_layer
    autocmd!
    autocmd FileType fzf setlocal nonumber norelativenumber
  augroup END

  call SpaceVim#mapping#space#def('nnoremap', ['j', 'i'], 'FzfOutline', 'jump to a definition in buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['T', 'c'], ' Colors', 'fuzzy find colorschemes', 1)

  call s:define_fuzzy_finder()
  call s:define_space_keymaps()
endfunction

function! s:define_space_keymaps()
  let g:_spacevim_mappings_space.z.name = '+Fzf'

  call SpaceVim#mapping#space#def('nnoremap', ['z', 'b'], 'Buffers',
        \ ['󰘙 buffers', [ '[SPC z b] is to list all buffers', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'c'], 'Changes',
        \ [' changes', [ '[SPC z c] is to list all changes in all buffers', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'C'], 'Commands',
        \ [' commands', [ '[SPC z C] is to list all vim commands', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'f'], 'FzfPreviewProjectFilesRpc',
        \ [' project files', [ '[SPC z f] is to list all files in project directory', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'F'], 'FzfPreviewDirectoryFilesRpc',
        \ [' directory files', [ '[SPC z F] is to list all files in project directory', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'u'], 'FzfPreviewProjectMruFilesRpc',
        \ [' mru files', [ '[SPC z u] is to list mru files in project', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'W'], 'FzfPreviewProjectMrwFilesRpc',
        \ [' mrw files', [ '[SPC z w] is to list mrw files in project', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'h'], 'Helptags',
        \ [' help tags', [ '[SPC z h] is to list help tags', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'H'], ':FzfPreviewGrepHelpRpc ',
        \ ['󰋗 help search', [ '[SPC z H] is to search helps', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 0)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'j'], 'Jumps',
        \ [' jumps', [ '[SPC z j] is to list jumps', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'k'], 'Marks',
        \ [' marks', [ '[SPC z k] is to list marks', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'l'], 'FzfPreviewLinesRpc',
        \ ['󱎸 buffer lines', [ '[SPC z l] is to list lines of current buffer', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'L'], 'Lines',
        \ ['󱎸 lines', [ '[SPC z L] is to list lines of all buffers', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'm'], 'FzfMessages',
        \ [' messages', [ '[SPC z m] is to list vim messages', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'p'], 'FzfMenu Projects',
        \ [' projects', [ '[SPC z p] is to list projects', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'r'], 'FzfMenu MyStarredrepos',
        \ ['留stared repos', [ '[SPC z r] is to list starred repos', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 0)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 's'], ':FzfPreviewProjectGrepRpc ',
        \ [' grep', [ '[SPC z s] is to grep string', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 't'], 'Filetypes',
        \ [' file types', [ '[SPC z t] is to switch filetype', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'W'], 'Windows',
        \ [' windows', [ '[SPC z W] is to list windows', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', '/'], ':RG ',
        \ ['󰺯 search string', [ '[SPC z /] is to search string', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 0)

  " Map
  let g:_spacevim_mappings_space.z.M = {'name' : '+Map'}
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'M', 'n'], 'Maps',
        \ [' normal mappings', [ '[SPC M n] is to list normal mode mappings', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'M', 'i'], 'IMaps',
        \ [' input mappings', [ '[SPC M i] is to list input mode mappings', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'M', 'v'], 'VMaps',
        \ [' visual mappings', [ '[SPC M v] is to list visual mode mappings', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)

  " History
  let g:_spacevim_mappings_space.z.h = {'name' : '+History'}
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'h', 'f'], 'History',
        \ [' file history', [ '[SPC z h f] is to list file history', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'h', ':'], 'History:',
        \ [' command history', [ '[SPC z h :] is to list vim command history', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['z', 'h', '/'], 'History/',
        \ ['󰺯 search history', [ '[SPC z h /] is to list search history', '', 'Definition: ' . s:filename . ':' . (expand('<sflnum>') - 1), ] ] , 1)
endfunction

let s:file = expand('<sfile>:~')
function! s:define_fuzzy_finder() abort
  if !s:fuzzy_finder 
    return
  endif

  let g:_spacevim_mappings.f = {'name' : '+Fuzzy Finder'}

  " let g:_spacevim_mappings.f.e = ['FzfRegister', 'fuzzy find registers',
        " \ [ '[Leader f r ] is to resume unite window', '', 'Definition: ' . s:file . ':' . (expand('<sflnum>') - 1), ] ]

  let g:_spacevim_mappings.f.j = ['FzfPreviewJumpsRpc', ' fuzzy find jump list',
        \ [ '[Leader f j] is to fuzzy find jump list', '', 'Definition: ' . s:file . ':' . (expand('<sflnum>') - 1), ] ]

  let g:_spacevim_mappings.f.y = ['FZFNeoyank', '󱘞 fuzzy find yank history',
        \ [ '[Leader f y ] is to resume unite window', '', 'Definition: ' . s:file . ':' . (expand('<sflnum>') - 1), ] ]

  let g:_spacevim_mappings.f.m = ['FzfMessages', ' fuzzy find message',
        \ [ '[Leader f m] is to fuzzy find message', '', 'Definition: ' . s:file . ':' . (expand('<sflnum>') - 1), ] ]

  " nnoremap <silent> <Leader>fq :<C-u>FzfQuickfix<CR>
  let g:_spacevim_mappings.f.q = ['FzfQuickfix', ' fuzzy find quickfix list',
        \ [ '[Leader f q] is to fuzzy find quickfix list', '', 'Definition: ' . s:file . ':' . (expand('<sflnum>') - 1), ] ]

  " nnoremap <silent> <Leader>fl :<C-u>FzfLocationList<CR>
  let g:_spacevim_mappings.f.l = ['FzfLocationList', 'fuzzy find location list',
        \ [ '[Leader f l] is to fuzzy find location list', '', 'Definition: ' . s:file . ':' . (expand('<sflnum>') - 1), ] ]
  
  nnoremap <silent> <Leader>fo  :<C-u>FzfOutline<CR>
  let g:_spacevim_mappings.f.o = ['FzfOutline', 'fuzzy find outline',
        \ [ '[Leader f o] is to fuzzy find outline', '', 'Definition: ' . s:file . ':' . (expand('<sflnum>') - 1), ] ]

  nnoremap <silent> <Leader>f<Space> :FzfMenu CustomKeyMaps<CR>
  let g:_spacevim_mappings.f['[SPC]'] = ['FzfMenu CustomKeyMaps', 'fuzzy find custom key bindings',
        \ [ '[Leader f SPC] is to fuzzy find custom key bindings', '', 'Definition: ' . s:file . ':' . (expand('<sflnum>') - 1), ] ]

  nnoremap <silent> <Leader>fp  :<C-u>FzfMenu AddedPlugins<CR>
  let g:_spacevim_mappings.f.p = ['FzfMenu AddedPlugins', 'fuzzy find vim packages',
        \ [ '[Leader f p] is to fuzzy find vim packages installed in SpaceVim', '', 'Definition: ' . s:file . ':' . (expand('<sflnum>') - 1), ] ]

  nnoremap <silent> <Leader>ft  :<C-u>FzfTags<CR>
  let g:_spacevim_mappings.f.t = ['FzfTags', 'fuzzy find global tags',
        \ [ '[Leader f t] is to fuzzy find global tags', '', 'Definition: ' . s:file . ':' . (expand('<sflnum>') - 1), ] ]
endfunction

" Function below is largely lifted directly out of project junegunn/fzf.vim from
" file autoload/fzf/vim.vim ; w/ minor mods to better integrate into SpaceVim
function! s:wrap(name, opts)
  " fzf#wrap does not append --expect if 'sink' is found
  let opts = copy(a:opts)
  let options = ''
  if has_key(opts, 'options')
    let options = type(opts.options) == v:t_list ? join(opts.options) : opts.options
  endif
  if options !~ '--expect' && has_key(opts, 'sink')
    call remove(opts, 'sink')
    let wrapped = fzf#wrap(a:name, opts)
  else
    let wrapped = fzf#wrap(a:name, opts)
  endif
  return wrapped
endfunction

command! -bar -bang IMaps call fzf#vim#maps("i", <bang>0)
command! -bar -bang VMaps call fzf#vim#maps("v", <bang>0)

let s:source = ''

function! SpaceVim#layers#fzf#sources() abort

  return s:source

endfunction

command! FzfMessages call <SID>message()
function! s:yankmessage(e) abort
  let @" = a:e
  echohl ModeMsg
  echo 'Yanked'
  echohl None
endfunction
function! s:message() abort
  let s:source = 'message'
  function! s:messagelist() abort
    return split(s:CMP.execute('message'), '\n')
  endfunction
  call fzf#run(fzf#wrap('messages', {
        \   'source':  reverse(<sid>messagelist()),
        \   'sink':    function('s:yankmessage'),
        \   'options': '+m',
        \   'down':    len(<sid>messagelist()) + 2
        \ }))
endfunction

command! FzfQuickfix call s:quickfix()
function! s:open_quickfix_item(e) abort
  let line = a:e
  let filename = fnameescape(split(line, ':\d\+:')[0])
  let linenr = matchstr(line, ':\d\+:')[1:-2]
  let colum = matchstr(line, '\(:\d\+\)\@<=:\d\+:')[1:-2]
  exe 'e ' . filename
  call cursor(linenr, colum)
endfunction
function! s:quickfix_to_grep(v) abort
  return bufname(a:v.bufnr) . ':' . a:v.lnum . ':' . a:v.col . ':' . a:v.text
endfunction
function! s:quickfix() abort
  let s:source = 'quickfix'
  function! s:quickfix_list() abort
    return map(getqflist(), 's:quickfix_to_grep(v:val)')
  endfunction
  call fzf#run(fzf#wrap('quickfix', {
        \ 'source':  reverse(<sid>quickfix_list()),
        \ 'sink':    function('s:open_quickfix_item'),
        \ 'options': '--reverse',
        \ 'down' : '40%',
        \ }))
endfunction
command! FzfLocationList call s:location_list()
function! s:location_list_to_grep(v) abort
  return bufname(a:v.bufnr) . ':' . a:v.lnum . ':' . a:v.col . ':' . a:v.text
endfunction
function! s:open_location_item(e) abort
  let line = a:e
  let filename = fnameescape(split(line, ':\d\+:')[0])
  let linenr = matchstr(line, ':\d\+:')[1:-2]
  let colum = matchstr(line, '\(:\d\+\)\@<=:\d\+:')[1:-2]
  exe 'e ' . filename
  call cursor(linenr, colum)
endfunction
function! s:location_list() abort
  let s:source = 'location_list'
  function! s:get_location_list() abort
    return map(getloclist(0), 's:location_list_to_grep(v:val)')
  endfunction
  call fzf#run(fzf#wrap('location_list', {
        \ 'source':  reverse(<sid>get_location_list()),
        \ 'sink':    function('s:open_location_item'),
        \ 'options': '--reverse',
        \ 'down' : '40%',
        \ }))
endfunction


command! -bang FzfOutline call fzf#run(fzf#wrap('outline', s:outline(), <bang>0))
function! s:outline_format(lists) abort
  for list in a:lists
    let linenr = list[2][:len(list[2])-3]
    let line = getline(linenr)
    let idx = stridx(line, list[0])
    let len = len(list[0])
    let list[0] = line[:idx-1] . printf("\x1b[%s%sm%s\x1b[m", 34, '', line[idx : idx+len-1]) . line[idx + len :]
  endfor
  for list in a:lists
    call map(list, "printf('%s', v:val)")
  endfor
  return a:lists
endfunction

function! s:outline_source(tag_cmds) abort
  if !filereadable(expand('%'))
    throw 'Save the file first'
  endif

  let lines = []
  for cmd in a:tag_cmds
    let lines = split(system(cmd), "\n")
    if !v:shell_error
      break
    endif
  endfor
  if v:shell_error
    throw get(lines, 0, 'Failed to extract tags')
  elseif empty(lines)
    throw 'No tags found'
  endif
  return map(s:outline_format(map(lines, 'split(v:val, "\t")')), 'join(v:val, "\t")')
endfunction

function! s:outline_sink(lines) abort
  if !empty(a:lines)
    let line = a:lines[0]
    execute split(line, "\t")[2]
  endif
endfunction

function! s:outline(...) abort
  let s:source = 'outline'
  let tag_cmds = [
        \ printf('ctags -f - --sort=no --excmd=number --language-force=%s %s 2>/dev/null', &filetype, expand('%:S')),
        \ printf('ctags -f - --sort=no --excmd=number %s 2>/dev/null', expand('%:S'))]
  return {
        \ 'source':  s:outline_source(tag_cmds),
        \ 'sink*':   function('s:outline_sink'),
        \ 'options': '--reverse +m -d "\t" --with-nth 1 -n 1 --ansi --prompt "Outline> "'}
endfunction


command! FzfRegister call <SID>register()
function! s:yankregister(e) abort
  let @" = a:e
  echohl ModeMsg
  echo 'Yanked'
  echohl None
endfunction
function! s:register() abort
  let s:source = 'registers'
  function! s:registers_list() abort
    return split(s:CMP.execute('registers'), '\n')[1:]
  endfunction
  call fzf#run(fzf#wrap('registers', {
        \   'source':  reverse(<sid>registers_list()),
        \   'sink':    function('s:yankregister'),
        \   'options': '+m',
        \   'down': '40%'
        \ }))
endfunction

let s:ansi = {'black': 30, 'red': 31, 'green': 32, 'yellow': 33, 'blue': 34, 'magenta': 35, 'cyan': 36}

function! s:get_color(attr, ...) abort
  let gui = has('termguicolors') && &termguicolors
  let fam = gui ? 'gui' : 'cterm'
  let pat = gui ? '^#[a-f0-9]\+' : '^[0-9]\+$'
  for group in a:000
    let code = synIDattr(synIDtrans(hlID(group)), a:attr, fam)
    if code =~? pat
      return code
    endif
  endfor
  return ''
endfunction
function! s:csi(color, fg) abort
  let prefix = a:fg ? '38;' : '48;'
  if a:color[0] ==# '#'
    return prefix.'2;'.join(map([a:color[1:2], a:color[3:4], a:color[5:6]], 'str2nr(v:val, 16)'), ';')
  endif
  return prefix.'5;'.a:color
endfunction

function! s:ansi(str, group, default, ...) abort
  let fg = s:get_color('fg', a:group)
  let bg = s:get_color('bg', a:group)
  let color = s:csi(empty(fg) ? s:ansi[a:default] : fg, 1) .
        \ (empty(bg) ? '' : s:csi(bg, 0))
  return printf("\x1b[%s%sm%s\x1b[m", color, a:0 ? ';1' : '', a:str)
endfunction
function! s:black(str, ...)
  return s:ansi(a:str, get(a:, 1, ''), 'black')
endfunction
function! s:blue(str, ...)
  return s:ansi(a:str, get(a:, 1, ''), 'blue')
endfunction
function! s:green(str, ...)
  return s:ansi(a:str, get(a:, 1, ''), 'green')
endfunction
function! s:cyan(str, ...)
  return s:ansi(a:str, get(a:, 1, ''), 'cyan')
endfunction
function! s:yellow(str, ...)
  return s:ansi(a:str, get(a:, 1, ''), 'yellow')
endfunction
function! s:magenta(str, ...)
  return s:ansi(a:str, get(a:, 1, ''), 'magenta')
endfunction
function! s:red(str, ...)
  return s:ansi(a:str, get(a:, 1, ''), 'red')
endfunction
function! s:helptag_sink(line) abort
  let [tag, file, path] = split(a:line, "\t")[0:2]
  unlet file
  let rtp = fnamemodify(path, ':p:h:h')
  if stridx(&rtp, rtp) < 0
    execute 'set rtp+='. fnameescape(rtp)
  endif
  execute 'help' tag
endfunction

" fzf menu command
function! SpaceVim#layers#fzf#complete_menu(ArgLead, CmdLine, CursorPos) abort
  return join(keys(g:unite_source_menu_menus), "\n")
endfunction

command! -nargs=* -complete=custom,SpaceVim#layers#fzf#complete_menu FzfMenu call <SID>menu(<q-args>)
function! s:menu_action(e) abort
  let action = get(s:menu_action, a:e, '')
  exe action
endfunction
function! s:menu(name) abort
  let s:source = 'menu'
  let s:menu_name = a:name
  let s:menu_action = {}
  function! s:menu_content() abort
    let menu = get(g:unite_source_menu_menus, s:menu_name, {})
    if has_key(menu, 'command_candidates')
      let rt = []
      for item in menu.command_candidates
        call add(rt, item[0])
        call extend(s:menu_action, {item[0] : item[1]}, 'force')
      endfor
      return rt
    else
      return []
    endif
  endfunction
  call fzf#run(fzf#wrap('menu', {
        \   'source':  reverse(<sid>menu_content()),
        \   'sink':    function('s:menu_action'),
        \   'options': '+m',
        \   'down': '40%'
        \ }))
endfunction


function! s:tags_sink(line) abort
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction

function! s:tags() abort
  if empty(tagfiles())
    echohl WarningMsg
    echom 'Preparing tags'
    echohl None
    call system('ctags -R')
  endif

  call fzf#run({
  \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
  \            '| grep -v -a ^!',
  \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index --reverse',
  \ 'down':    '40%',
  \ 'sink':    function('s:tags_sink')})
endfunction

command! FzfTags call s:tags()
