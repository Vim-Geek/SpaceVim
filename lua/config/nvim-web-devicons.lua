local devicons = require('nvim-web-devicons')

devicons.setup {
  -- your personnal icons can go here (to override)
  -- you can specify color or cterm_color instead of specifying both of them
  -- DevIcon will be appended to `name`
  --
  override = {
  },
  --
  -- globally enable different highlight colors per icon (default to true)
  -- if set to false all icons will have the default icon's color
  color_icons = true,
  --
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true,

  -- globally enable "strict" selection of icons - icon will be looked up in
  -- different tables, first by filename, and if not found by extension; this
  -- prevents cases when file doesn't have any extension but still gets some icon
  -- because its name happened to match some extension (default to false)
  strict = true,

  -- same as `override` but specifically for overrides by filename
  -- takes effect when `strict` is true
  override_by_filename = {
    [".gitignore"] = {
      icon = "",
      color = "#f34e32",
      name = "Gitignore"
    },
    [".gitconfig"] = {
      icon = "",
      color = "#f34e32",
      name = "Gitconfig"
    },
    ["gitignore"] = {
      icon = "",
      color = "#f34e32",
      name = "Gitignore"
    },
    ["gitconfig"] = {
      icon = "",
      color = "#f34e32",
      name = "Gitconfig"
    },
    [".gitkeep"] = {
      icon = "",
      color = "#f34e32",
      name = "Gitkeep"
    },
    [".gitattributes"] = {
      icon = "",
      color = "#f34e32",
      name = "GitAttributes",
    },
    [".gitmodules"] = {
      icon = "",
      color = "#f34e32",
      name = "GitModules",
    },
    ["zshrc"] = {
      icon = "",
      color = "#f34e32",
      name = "ZshConfig",
    },
    [".zshrc"] = {
      icon = "",
      color = "#f34e32",
      name = "ZshConfig",
    },
    ["zshenv"] = {
      icon = "",
      color = "#f34e32",
      name = "ZshConfig",
    },
    [".zshenv"] = {
      icon = "",
      color = "#f34e32",
      name = "ZshConfig",
    },
    ["zprofile"] = {
      icon = "",
      color = "#f34e32",
      name = "ZshConfig",
    },
    [".zprofile"] = {
      icon = "",
      color = "#f34e32",
      name = "ZshConfig",
    },
    ["zlogin"] = {
      icon = "",
      color = "#f34e32",
      name = "ZshConfig",
    },
    [".zlogin"] = {
      icon = "",
      color = "#f34e32",
      name = "ZshConfig",
    },
    ["zlogout"] = {
      icon = "",
      color = "#f34e32",
      name = "ZshConfig",
    },
    [".zlogout"] = {
      icon = "",
      color = "#f34e32",
      name = "ZshConfig",
    },
    ["package.json"] = {
      icon = "",
      color = "#6ace66",
      name = "PackageJson",
    },
    ["tsconfig.json"] = {
      icon = "ﯤ",
      color = "#367ac4",
      name = "TypescriptConfig",
    },
    ["makefile"] = {
      icon = "",
      color = "#963630",
      name = "Makefile",
    },
  },
  -- same as `override` but specifically for overrides by extension
  -- takes effect when `strict` is true
  override_by_extension = {
    ["nvim"] = {
      icon = "",
      color = "#61ff00",
      cterm_color = "113",
      name = "Neovim"
    },
    ["snippets"] = {
      icon = "ﴬ",
      color = "#6dbfc5",
      name = "Snippet"
    },
    ["sh"] = {
      icon = "",
      color = "#2e8ccf",
      cterm_color = "240",
      name = "Sh",
    },
    ["zsh"] = {
      icon = "",
      color = "#C1D23C",
      cterm_color = "65",
      name = "Zsh"
    },
    ["zsh-theme"] = {
      icon = "",
      color = "#ea005a",
      name = "ZshTheme"
    },
    -- ["log"] = {
    -- icon = "",
    -- color = "#81e043",
    -- name = "Log"
    -- }
  },
}
