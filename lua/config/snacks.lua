--!/usr/bin/lua

local status, snacks = pcall(require, "Snacks")

if status then
  snacks.setup({
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = false },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = {
      enabled = false,
      timeout = 5000, -- default timeout in ms
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      -- editor margin to keep free. tabline and statusline are taken into account automatically
      margin = { top = 0, right = 1, bottom = 0 },
      padding = true,              -- add 1 cell of left/right padding to the notification window
      sort = { "level", "added" }, -- sort by level and time
      -- minimum log level to display. TRACE is the lowest
      -- all notifications are stored in history
      level = vim.log.levels.TRACE,
      icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = " ",
      },
      keep = function(notif)
        return vim.fn.getcmdpos() > 0
      end,
      ---@type snacks.notifier.style
      style = "fancy",
      top_down = true,    -- place notifications from top to bottom
      date_format = "%R", -- time format for notifications
      -- format for footer when more lines are available
      -- `%d` is replaced with the number of lines.
      -- only works for styles with a border
      ---@type string|boolean
      more_format = " ↓ %d lines ",
      refresh = 50, -- refresh at most every 50ms

    },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification_history = {
        border = true,
        zindex = 100,
        width = 0.8,
        height = 0.9,
        minimal = false,
        title = " Notification History ",
        title_pos = "center",
        ft = "markdown",
        bo = { filetype = "snacks_notif_history", modifiable = false },
        wo = { winhighlight = "Normal:SnacksNotifierHistory" },
        keys = { q = "close" },
      }
    }
  })


  vim.api.nvim_set_hl(0, "SnacksInputBorder", { link = 'CocFloatingBorder' })
  vim.api.nvim_set_hl(0, "SnacksInputTitle", { link = 'CocFloatingTitle' })

  -- vim.api.nvim_set_hl(0, "SnacksNotifierFooterError", { fg = '#DC143C', bold = true })
  -- vim.api.nvim_set_hl(0, "SnacksNotifierBorderError", { fg = '#DC143C', bold = true })
  -- vim.api.nvim_set_hl(0, "SnacksNotifierTitleError", { fg = '#DC143C', bold = true })
  -- vim.api.nvim_set_hl(0, "SnacksNotifierFooterWarn", { fg = '#EF7722', bold = true })
  -- vim.api.nvim_set_hl(0, "SnacksNotifierBorderWarn", { fg = '#EF7722', bold = true })
  -- vim.api.nvim_set_hl(0, "SnacksNotifierTitleWarn", { fg = '#EF7722', bold = true })
  -- vim.api.nvim_set_hl(0, "SnacksNotifierFooterInfo", { fg = '#0BA6DF', bold = true })
  -- vim.api.nvim_set_hl(0, "SnacksNotifierBorderInfo", { fg = '#0BA6DF', bold = true })
  -- vim.api.nvim_set_hl(0, "SnacksNotifierTitleInfo", { fg = '#0BA6DF', bold = true })
  --
  -- _G.dd = function(...)
  -- Snacks.debug.inspect(...)
  -- end
  -- _G.bt = function()
  -- Snacks.debug.backtrace()
  -- end
  --
  -- _G.log = function(...)
  -- Snacks.debug.log(...)
  -- end
  --
  -- _G.show_history = function()
  -- Snacks.notifier.show_history({
  -- filter = "trace",
  -- })
  -- end
  --
  -- if vim.fn.has("nvim-0.11") == 1 then
  -- @diagnostic disable-next-line: duplicate-set-field
  -- vim._print = function(_, ...)
  -- dd(...)
  -- end
  -- else
  -- vim.print = dd
  -- end
end
