local M = {}

function M.setup()
  require('nvim-treesitter.configs').setup({
    -- A directory to install the parsers into.
    -- If this is excluded or nil parsers are installed
    -- to either the package dir, or the "site" dir.
    -- If a custom path is used (not nil) it must be added to the runtimepath.
    -- parser_install_dir = "/some/path/to/store/parsers",

    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = {
      "angular", "awk",
      "bash",
      "c", "cmake", "cpp", "css", "csv", "cuda",
      "dart", "diff", "dockerfile", "dtd",
      "editorconfig", "func",
      "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore", "go", "gomod", "graphql", "groovy",
      "helm", "html", "http",
      "ini",
      "java", "javascript", "jq", "jsdoc", "json", "json5", "jsonc",
      "kotlin",
      "latex", "liquid", "llvm", "lua", "luadoc",
      "make", "markdown", "markdown_inline", "mermaid",
      "nginx",
      "passwd", "pem", "perl", "php", "prisma", "properties", "proto", "pug", "python",
      "regex", "requirements", "rst", "ruby", "rust",
      "scala", "scss", "solidity", "sql", "ssh_config", "svelte", "swift",
      "tmux", "toml", "tsx", "typescript",
      "vim", "vimdoc", "vue",
      "xml",
      "yaml",
      "zig",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = {},
    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
      enable = true,

      -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
      -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
      -- the name of the parser)
      -- list of language that will be disabled
      -- disable = { "c", "rust" },
      -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
      disable = function(lang, buf)
        local max_filesize = 4 * 1024 * 1024 -- 4MB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },

    indent = {
      enable = true,
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "vs", -- set to `false` to disable one of the mappings
        node_incremental = "sj",
        node_decremental = "sk",
        scope_incremental = "ss",
      },
    },
  })

  vim.treesitter.language.register('markdown', 'mdx')

  -- local config
  local status, local_config = pcall(require, "plugins/nvim-treesitter_local")
end

return M
