"=============================================================================
" rust.vim --- SpaceVim rust layer
"=============================================================================

" @subsection Mappings
" >
"   Key         Function
"   -----------------------------------------------
"   g d             jump to type definition
"   SPC l a         code actions
"   SPC l d         go to definition
"   SPC l D         go to declaration
"   SPC l f         find references
"   SPC l F         format code
"   SPC l i         go to implementation
"   SPC l t         go to type definition
"
"   SPC l k         show documentation
"   SPC l R         rename symbol
"
"   SPC l C         open Cargo.toml
"   SPC l e         explain error message
"   SPC l j         join lines
"   SPC l K         open documentation
"   SPC l m         expand macro
"   SPC l T         test current
"
" <
"  + Cargo
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l c a       cargo add
"   SPC l c r       cargo run
"   SPC l c b       cargo build
"   SPC l c c       cargo clean
"   SPC l c t       cargo test
"   SPC l c C       cargo clippy
"   SPC l c u       cargo update
"   SPC l c B       cargo bench
"   SPC l c d       cargo doc
"   SPC l c f       cargo fmt
"
" <
"  + REPL
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
"
" <
"  + Run
" >
"   key binding     Description
"   ----------------------------------------
"
"   SPC l r l      list available runnables
"   SPC l r b      execute task bundle
"   SPC l r r      run tasks
"   SPC l r t      open task list
"
" <

if exists('s:rustfmt_cmd')
  finish
else
  let s:recommended_style = 0
  let s:format_on_save = 0
  let s:rustfmt_cmd = 'rustfmt'
endif

function! SpaceVim#layers#lang#rust#plugins() abort
  let plugins = []
  " call add(plugins, [g:_spacevim_root_dir . 'bundle/rust.vim', {'merged' : 0}])
  " if !SpaceVim#layers#lsp#check_filetype('rust')
        " \ && !SpaceVim#layers#lsp#check_server('rls')
        " \ && !SpaceVim#layers#lsp#check_server('rust_analyzer')
    " call add(plugins, ['racer-rust/vim-racer', {'merged' : 0}])
  " endif
  "
  call add(plugins, ['rust-lang/rust.vim', {'merged' : 0}])
  call add(plugins, ['stevearc/overseer.nvim', {'merged' : 0}])
  call add(plugins, ['rouge8/neotest-rust', {'merged' : 0}])
  call add(plugins, ['Arne-Berner/nvim-clippy', {'merged' : 0}])
  " call add(plugins, ['alexpasmantier/krust.nvim', {'merged' : 0, 'on_ft': 'rust'}])

  " call add(plugins, ['mrcjkb/rustaceanvim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#rust#config() abort
  call SpaceVim#plugins#runner#reg_runner('rust', [
        \ 'rustc %s -o #TEMP#',
        \ '#TEMP#'])
  call SpaceVim#plugins#repl#reg('rust', 'evcxr')

  let g:rustfmt_cmd = s:rustfmt_cmd
  " format layer setting
  let g:neoformat_rust_rustfmt = {
        \ 'exe': s:rustfmt_cmd,
        \ 'stdin': 1,
        \ }
  let g:neoformat_enabled_rust = ['rustfmt']
  let g:rust_recommended_style = s:recommended_style
  " Disable racer format, use Neoformat instead!
  let g:rustfmt_autosave = 0
  if s:format_on_save
    call SpaceVim#layers#format#add_filetype({
          \ 'filetype' : 'rust',
          \ 'enable' : 1,
          \ })
  endif

  call SpaceVim#mapping#space#regesit_lang_mappings('rust', function('s:language_specified_mappings'))
  call add(g:spacevim_project_rooter_patterns, 'Cargo.toml')

  if SpaceVim#layers#lsp#check_filetype('rust')
        \ || SpaceVim#layers#lsp#check_server('rls')
        \ || SpaceVim#layers#lsp#check_server('rust_analyzer')
    call SpaceVim#mapping#gd#add('rust', function('SpaceVim#lsp#go_to_def'))
  else
    call SpaceVim#mapping#gd#add('rust', function('s:gotodef'))
  endif
endfunction

function! SpaceVim#layers#lang#rust#set_variable(var) abort
  " support old option recommended-style and recommended_style
  let s:recommended_style = get(a:var, 'recommended_style',
        \ get(a:var, 'recommended-style',
        \ s:recommended_style))
  " support old option format-autosave and format_on_save
  let s:format_on_save = get(a:var, 'format_on_save',
        \ get(a:var, 'format-autosave', s:format_on_save))
  " support old option rustfmt-cmd and rustfmt_cmd
  let s:rustfmt_cmd = get(a:var, 'rustfmt_cmd',
        \ get(a:var, 'rustfmt-cmd', s:rustfmt_cmd))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'a'], '<Plug>(coc-codeaction)', ' code actions', 0)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'], '<Plug>(coc-definition)', ' go to definition', 0)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'D'], '<Plug>(coc-declaration)', ' go to declaration', 0)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'f'], '<Plug>(coc-references)', ' find references', 0)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'F'], '<Plug>(coc-format)', '󱉯 format code', 0)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'i'], '<Plug>(coc-implementation)', ' go to implementation', 0)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 't'], '<Plug>(coc-type-definition)', ' go to type definition', 0)

  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'k'], 'call CocActionAsync("doHover")', ' show documentation', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'R'], 'call CocAction("refactor")', '凜rename symbol', 1)

  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'C'], 'CocCommand rust-analyzer.openCargoToml', ' open Cargo.toml', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'], 'CocCommand rust-analyzer.explainError', '󱪗 explain error message', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'j'], 'CocCommand rust-analyzer.joinLines', ' join lines', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'K'], 'CocCommand rust-analyzer.openDocs', ' open documentation', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'm'], 'CocCommand rust-analyzer.expandMacro', '󰪴 expand macro', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'T'], 'CocCommand rust-analyzer.testCurrent', ' test current', 1)


  let g:_spacevim_mappings_space.l.r = {'name' : '+Run'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r', 'l'], 'CocCommand rust-analyzer.run', ' list available runnables', 1)
  " call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r', 'b'], 'OverseerLoadBundle', ' execute task bundle', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r', 't'], 'OverseerRun', '  list run tasks', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r', 'L'], 'OverseerToggle', ' open task list', 1)

  let g:_spacevim_mappings_space.l.c = {'name' : '+Cargo'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'a'], 'exe "!cargo add ". expand("<cword>")', ' cargo add', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'r'], 'call call(' . string(function('s:execCMD')) . ', ["cargo run"])', ' cargo run', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'b'], 'call call(' . string(function('s:execCMD')) . ', ["cargo build"])', ' cargo build', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'c'], 'call call(' . string(function('s:execCMD')) . ', ["cargo clean"])', ' cargo clean', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 't'], 'call call(' . string(function('s:execCMD')) . ', ["cargo test"])', ' cargo test', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'C'], 'call call(' . string(function('s:execCMD')) . ', ["cargo clippy"])', ' cargo clippy', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'u'], 'call call(' . string(function('s:execCMD')) . ', ["cargo update"])', ' cargo update', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'B'], 'call call(' . string(function('s:execCMD')) . ', ["cargo bench"])', ' cargo bench', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'd'], 'call call(' . string(function('s:execCMD')) . ', ["cargo doc"])', ' cargo doc', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'f'], 'call call(' . string(function('s:execCMD')) . ', ["cargo fmt"])', '󱉯 cargo fmt', 1)

  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'], 'call SpaceVim#plugins#repl#start("rust")', ' start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'], 'call SpaceVim#plugins#repl#send("line")', ' send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'], 'call SpaceVim#plugins#repl#send("buffer")', ' send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'], 'call SpaceVim#plugins#repl#send("selection")', ' send selection and keep code buffer focused', 1)

  " if api#utils#exist_plugin('nvim-dap')
    " let g:_spacevim_mappings_space.l.g = {'name' : '+Debug'}
  " endif

endfunction

function! s:gotodef() abort
  try
    call CocActionAsync('jumpDefinition')
  catch
    exec 'normal! gd'
  endtry
endfunction

function! s:execCMD(cmd) abort
  call SpaceVim#plugins#runner#open(a:cmd)
endfunction

function! SpaceVim#layers#lang#rust#health() abort
  call SpaceVim#layers#lang#rust#plugins()
  call SpaceVim#layers#lang#rust#config()
  return 1
endfunction

"
" toolchain
"
" set RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
"
"  rustup
"
" set RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
"

" vim:set et sw=2 cc=80
