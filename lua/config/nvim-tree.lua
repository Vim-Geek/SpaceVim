--!/usr/bin/lua

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colours
vim.opt.termguicolors = true

local api = require("nvim-tree.api")

-- keymap
local function on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- use all default mappings
  api.map.on_attach.default(bufnr)

  -- remove a default
  vim.keymap.del("n", "y", { buffer = bufnr })
  vim.keymap.del("n", "Y", { buffer = bufnr })
  vim.keymap.del("n", "g?", { buffer = bufnr })
  vim.keymap.del("n", "ge", { buffer = bufnr })
  vim.keymap.del("n", "gp", { buffer = bufnr })
  vim.keymap.del({ "n", "x" }, "gy", { buffer = bufnr })

  -- override a default
  vim.keymap.set("n", "<CR>", api.tree.change_root_to_node, opts("CD"))
  vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
  vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
  vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
  vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
  vim.keymap.set("n", "-", api.node.navigate.parent_close, opts("Close Directory"))
  vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
  vim.keymap.set("n", "<BS>", api.tree.change_root_to_parent, opts("Up"))
  vim.keymap.set("n", "a", api.fs.create, opts("Create File Or Directory"))
  vim.keymap.set("n", "bD", api.marks.bulk.delete, opts("Delete Bookmarked"))
  vim.keymap.set("n", "bd", api.marks.bulk.trash, opts("Trash Bookmarked"))
  vim.keymap.set({ "n", "x" }, "yy", api.fs.copy.node, opts("Copy"))
  vim.keymap.set({ "n", "x" }, "D", api.fs.remove, opts("Delete"))
  vim.keymap.set({ "n", "x" }, "d", api.fs.trash, opts("Trash"))
  vim.keymap.set("n", "]d", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
  vim.keymap.set("n", "[d", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
  vim.keymap.set({ "n", "x" }, "yp", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
  vim.keymap.set("n", "ye", api.fs.copy.basename, opts("Copy Basename"))
  -- vim.keymap.set("n", "c", api.fs.move, opts("Move"))
  vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
  vim.keymap.set("n", "u", api.node.navigate.parent, opts("Parent Directory"))
  vim.keymap.set("n", "q", api.tree.close, opts("Close"))
  vim.keymap.set("n", "X", api.node.run.system, opts("Run System"))
  vim.keymap.set("n", "s", api.tree.search_node, opts("Search"))
  vim.keymap.set("n", "R", api.fs.rename_full, opts("Rename: Full Path"))
  vim.keymap.set("n", "yf", api.fs.copy.filename, opts("Copy Name"))
  vim.keymap.set("n", "yd", api.fs.copy.relative_path, opts("Copy Relative Path"))
end

-- empty setup using defaults: add your own options
require 'nvim-tree'.setup {
  reload_on_bufenter = true,
  update_focused_file = {
    enable = true,
  },
  sort = {
    -- sorter = "case_sensitive",
  },
  view = {
    side = vim.api.nvim_eval('g:spacevim_filetree_direction'),
    signcolumn = "no",
    width = vim.api.nvim_eval('g:spacevim_sidebar_width'),
  },
  renderer = {
    group_empty = true,
    icons = {
      bookmarks_placement = 'right_align',
      git_placement = 'right_align',
      glyphs = {
        bookmark = '',
        git = {
          unstaged = '',
          staged = '',
          unmerged = '',
          renamed = '',
          untracked = '',
          deleted = '',
          ignored = '',
        },
      }
    }
  },
  filters = {
    enable = true,
  },
  bookmarks = {
    persist = true,
  },

  on_attach = on_attach,
}
