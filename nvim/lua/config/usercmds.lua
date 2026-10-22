

vim.api.nvim_create_user_command("TSRestart", function()
  vim.treesitter.stop()
  vim.treesitter.start()
end, {})
