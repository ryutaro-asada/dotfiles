-- Neovim options configuration

-- General settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Language
vim.cmd("language en_US.utf-8")

-- Editor options
local options = {
  -- File encoding
  encoding = "utf-8",
  fileencoding = "utf-8",

  -- Line numbers
  number = true,
  relativenumber = false,

  -- Search
  hlsearch = true,
  ignorecase = true,
  smartcase = true,

  -- Mouse and clipboard
  mouse = "a",
  clipboard = "unnamedplus",

  -- Indentation
  breakindent = true,
  smartindent = true,

  -- Files
  undofile = true,
  swapfile = false,
  backup = false,
  autochdir = false,

  -- UI
  signcolumn = "yes",
  wrap = false,
  completeopt = { "menuone", "noselect" },

  -- Performance
  updatetime = 250,
  timeoutlen = 310,
}

-- Apply options
for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Disable netrw (for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
