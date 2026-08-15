"=============================================================================
" git.vim --- SpaceVim git layer
" Author: Phoenix Xu < xusiyuan841028@gmail.com >
" License: MIT
"=============================================================================
""
" @section git, layers-git
" @parentsection layers
" `git` layer provides git integration for SpaceVim.
"
" @subsection Layer options
"
" >
"   [[layers]]
"     name = 'git'
" <
" `git_diff_position`: set the default command to split diff windows, by
" default it is `10split`. Example:
" >
"   [[layers]]
"     name = 'git'
"     git_diff_position = 'vsplit'
" <
" @subsection Key bindings
"
" The following key bindings will be definded when the `git` layer is loaded.
" >
"   Key Binding   Description
"   SPC g a       stage current file
"   SPC g A       stage all files
"   SPC g b       view git blame
"   SPC g d       reset file
"   SPC g D       view git diff
"   SPC g e       edit git commit
"   SPC g F       fold unchanged
"   SPC g i       show chunk diff
"   SPC g I       list gitignore templates
"   SPC g j       go to next conflict
"   SPC g k       go to previous conflict
"   SPC g l       git changes
"   SPC g p       git pull
"   SPC g P       git push
"   SPC g r       unstage current file
"   SPC g R       unstage all files
"   SPC g s       git status
"   SPC g S       git stashes
"   SPC g c       +Commits
"   SPC g c a     view logs of curren repository
"   SPC g c f     view logs of current file
"   SPC g c m     show commit message of current position
"   SPC g c p     show commits  of current position
"   SPC g h       +Hunks
"   SPC g h a     stage hunk
"   SPC g h d     reset hunk
"   SPC g h j     go to next hunk
"   SPC g h k     go to previous hunk
"   SPC g h r     unstage hunk
"   SPC g h s     select hunk
"   SPC g h v     preview hunk
"   SPC g m       +Merge Conflict
"   SPC g m b     apply both
"   SPC g m B     apply both in reverse order
"   SPC g m n     apply none
"   SPC g m o     apply ours
"   SPC g m t     apply theirs
"   SPC g t       +UI Toggles
"   SPC g t w     show word diff
"   SPC g t l     highlight line diff
"   SPC g t d     show the old version of chunks
"   SPC g v       +Diffview
"   SPC g v a     file history of repository
"   SPC g v d     open git diff
"   SPC g v f     file history of current file
"   SPC g v o     open diffview
" <
" @subsection commit omni function
" This layer also provides an omnifunc for git commit messages. It supports:
" 1. complete commit title, `fix:`, `doc:` etc.
" 2. complete github issue list
" 3. complete co-author info


if exists('s:git_plugin')
  finish
endif

let s:git_plugin = 'fugitive'

function! SpaceVim#layers#git#plugins() abort
  let plugins = []
  call add(plugins, ['tpope/vim-fugitive', { 'merged' : 0}])
  call add(plugins, ['tpope/vim-dispatch', { 'merged' : 0}])
  call add(plugins, ['tpope/vim-rhubarb', { 'merged' : 0}])
  call add(plugins, ['sindrets/diffview.nvim', { 'merged' : 0}])
  call add(plugins, ['rhysd/conflict-marker.vim', { 'merged' : 0}])
  call add(plugins, ['rhysd/git-messenger.vim', { 'merged' : 0, 'on_cmd': ['GitMessenger'], 'on_map': ['<Plug>(git-messenger)']}])
  call add(plugins, ['rhysd/committia.vim', { 'merged' : 0}])
  call add(plugins, ['lewis6991/gitsigns.nvim', { 'merged' : 0}])
  call add(plugins, ['isakbm/gitgraph.nvim', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#git#config() abort
  let g:_spacevim_mappings_space.g = get(g:_spacevim_mappings_space, 'g',  {'name' : '+Git'})
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'a'], 'Git add %', '󱌟 stage current file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'A'], 'Git add .', '󱉤 stage all files', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'b'], 'Gitsigns blame', ' view git blame', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'B'], 'FzfPreviewGitBranchesRpc', ' git branches', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'd'], 'Gitsigns reset_buffer', '󰦛 reset file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'D'], 'Gdiffsplit', ' view git diff', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'e'], 'Git commit', ' edit git commit', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'F'], 'CocCommand git.foldUnchanged', ' fold unchanged', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'i'], '<Plug>(coc-git-chunkinfo)', ' Show chunk diff', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'I'], 'CocList gitignore', ' list gitignore templates  asdfasdf', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'j'], '<Plug>(coc-git-nextconflict)', '󰒭 go to next conflict', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'k'], '<Plug>(coc-git-prevconflict)', '󰒮 go to previous conflict', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'l'], 'Gitsign setqflist', ' git changes', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'p'], 'Git pull', ' git pull', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'P'], 'Git push', ' git push', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'r'], 'Git reset -q %', '󱘙 unstage current file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'R'], 'Git reset', '󱘝 unstage all files', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 's'], 'FzfPreviewGitStatusRpc', '󱖫 git status', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'S'], 'FzfPreviewGitStashRpc', '󰃨 git stashes', 1)
  " call SpaceVim#mapping#space#def('nnoremap', ['g', 'l'], 'CocList -A --height=20 --normal gstatus', 'list git status', 1)
  " call SpaceVim#mapping#space#def('nnoremap', ['g', 'v'], 'tab Gclog -- %', 'view git logs of file', 1)
  " call SpaceVim#mapping#space#def('nnoremap', ['g', 'V'], 'tab Gclog --', 'view git logs of repo', 1)

  let g:_spacevim_mappings_space.g.c = {'name' : '+Commits'}
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'c', 'a'], 'Commits', ' view logs of current repository ', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'c', 'f'], 'BCommits', ' view logs of current file', 1)
  " call SpaceVim#mapping#space#def('nnoremap', ['g', 'c', 'p'], '<Plug>(coc-git-commit)', ' show commits of current position', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'c', 'm'], 'GitMessenger', '󰍩 show commit message of current position ', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'c', 'p'], 'FzfPreviewGitCurrentLogs', ' show commit of current position', 1)

  let g:_spacevim_mappings_space.g.h = {'name' : '+Hunks'}
  let l:h_submenu_name = SpaceVim#layers#isLoaded('github') ? '+GitHub/Hunks' : '+Hunks'
  let g:_spacevim_mappings_space.g.h['name'] = l:h_submenu_name

  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 'a'], 'Gitsigns stage_hunk', '󱌟 stage hunk', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 'd'], 'Gitsigns reset_hunk', '󰦛 reset hunk', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 'j'], '<Plug>(coc-git-nextchunk)', '󰥭 go to next chunk', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 'k'], '<Plug>(coc-git-prevchunk)', '󰥼 go to previous chunk', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 'r'], 'Gitsigns undo_stage_hunk', '󱘙 unstage hunk', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 's'], 'Gitsigns select_hunk', '󰄵 select hunk', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 'v'], 'Gitsigns preview_hunk', ' preview hunk', 1)

  let g:_spacevim_mappings_space.g.m = {'name' : '+Merge Conflict'}
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'm', 'b'], 'ConflictMarkerBoth', 'apply both', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'm', 'n'], 'ConflictMarkerNone', 'apply none', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'm', 'r'], 'ConflictMarkerBoth!', 'apply both in reverse order', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'm', 't'], 'ConflictMarkerThemselves', 'apply theirs', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'm', 'u'], 'ConflictMarkerOurselves', 'apply ours', 1)

  let g:_spacevim_mappings_space.g.t = {'name' : '+UI Toggles'}
  call SpaceVim#mapping#space#def('nnoremap', ['g', 't', 'w'], 'Gitsigns toggle_word_diff', ' show word diff', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 't', 'l'], 'Gitsigns toggle_linehl', ' highlight line diff', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 't', 'd'], 'Gitsigns toggle_deleted', ' show the old version of hunks', 1)

  let g:_spacevim_mappings_space.g.v = {'name' : '+Diffview'}
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'v', 'a'], 'DiffviewFileHistory', '󰳏 file history of repository', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'v', 'b'], 'DiffviewFileHistory %', ' file history of current file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'v', 'd'], 'Gdiffsplit', ' file diff', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'v', 's'], 'DiffviewOpen', ' open diffview', 1)

  augroup spacevim_layer_git
    autocmd!
    autocmd FileType diff nnoremap <buffer><silent> q :call SpaceVim#mapping#close_current_buffer()<CR>
    autocmd FileType gitcommit setl omnifunc=SpaceVim#plugins#gitcommit#complete
    if SpaceVim#layers#isLoaded('core#statusline')
      autocmd User GitGutter let &l:statusline = SpaceVim#layers#core#statusline#get(1)
    endif
    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
  augroup END

endfunction

function! SpaceVim#layers#git#set_variable(var) abort

  let s:git_plugin = get(a:var, 'git_plugin', s:git_plugin)
  let g:git_diff_position = get(a:var, 'git_diff_position', '10split')

endfunction

function! SpaceVim#layers#git#health() abort
  call SpaceVim#layers#git#plugins()
  call SpaceVim#layers#git#config()

  return 1

endfunction

function! SpaceVim#layers#git#loadable() abort

  return 1

endfunction

" vim:set et sw=2 cc=80:
