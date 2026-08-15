lua require('telescope').load_extension('menu')
lua require('telescope').load_extension('messages')
lua require('telescope').load_extension('project')
lua require('telescope').load_extension('scriptnames')
lua require('telescope').load_extension('neoyank')
lua require('telescope').load_extension('task')
lua require('telescope').load_extension('neomru')
lua require("telescope").load_extension("coc")

if SpaceVim#layers#isLoaded('tools')
  lua require('telescope').load_extension('bookmarks')
endif
if filereadable(g:_spacevim_root_dir . 'bundle/telescope-fzf-native.nvim/build/libfzf.so')
      \ || filereadable(g:_spacevim_root_dir . 'bundle/telescope-fzf-native.nvim/build/libfzf.dll')
  lua require('telescope').load_extension('fzf')
endif
if g:spacevim_snippet_engine ==# 'ultisnips'
  lua require('telescope').load_extension('ultisnips')
endif

lua <<EOF
local actions = require("telescope.actions")
local state = require("telescope.state")
local action_state = require("telescope.actions.state")

local slow_scroll = function(prompt_bufnr, direction)
  local previewer = action_state.get_current_picker(prompt_bufnr).previewer
  local status = state.get_status(prompt_bufnr)

  -- Check if we actually have a previewer and a preview window
  if type(previewer) ~= "table" or previewer.scroll_fn == nil or status.preview_win == nil then
    return
  end

  previewer:scroll_fn(1 * direction)
 end

require("telescope").setup{
  extensions = {
    coc = {
      -- theme = 'dropdown',
      prefer_locations = true,    -- always use Telescope locations to preview definitions/declarations/implementations etc
      push_cursor_on_edit = true, -- save the cursor position to jump back in the future
      timeout = 3000,             -- timeout for coc commands
    },
  },
  defaults = {
    mappings = {
      i = {
        -- the default key binding should same as other fuzzy finder layer
        -- tab move to next
        ["<C-f>"] = function(bufnr) slow_scroll(bufnr, 1) end,
        ["<C-b>"] = function(bufnr) slow_scroll(bufnr, -1) end,       

        ["<C-j>"] = actions.move_selection_next,
        ["<Tab>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<S-Tab>"] = actions.move_selection_previous,
        ["<Esc>"] = actions.close,
        ["<C-h>"] = "which_key",
    },
    },
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "bottom"
    }
  }
}

EOF
