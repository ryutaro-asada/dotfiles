-- ===========================
-- Neovim Configuration
-- ===========================

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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
-- Every file in lua/plugins/*.lua is imported as a plugin spec.
require("lazy").setup("plugins", {
  -- No plugin here needs luarocks; enabling it only causes build failures
  -- (e.g. oxocarbon.nvim) because Lua 5.1 isn't installed.
  rocks = { enabled = false },
})

-- Load LSP configuration
require('lsp.servers')

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
