let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
let g:EditorConfig_disable_rules = []

au FileType gitcommit let b:EditorConfig_disable = 1
