-- ===========================
-- Neovim Configuration
-- ===========================

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration modules
require('config.options')  -- Vim options and settings
require('config.keymaps')  -- Key mappings
require('config.autocmds') -- Auto commands
require('config.usercmds') -- User commands

-- Setup plugins with lazy.nvim
require("lazy").setup("plugins")

-- Load LSP configuration
require('lsp.servers')

-- Load plugin configurations
require('plugins.telescope')
require('plugins.cmp')

-- Set color scheme
-- vim.cmd [[colorscheme gruvbox]]
--
-- vim.g.everforest_background = 'hard'
-- vim.g.everforest_enable_italic = 1
-- vim.cmd [[colorscheme everforest]]
--
-- vim.opt.background = "dark" -- set this to dark or light
-- vim.cmd.colorscheme "oxocarbon"
--
vim.cmd.colorscheme "cyberdream"
