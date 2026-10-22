-- GitHub Copilot via Neovim's built-in LSP client (Neovim 0.12+)
--
-- Replaces copilot.vim. copilot-language-server provides:
--   * textDocument/inlineCompletion -> ghost text, handled by vim.lsp.inline_completion
--   * Next Edit Suggestions         -> handled by sidekick.nvim (lua/plugins/init.lua)
--
-- Install:  npm i -g @github/copilot-language-server
-- Sign in:  :LspCopilotSignIn  (auth is shared with copilot.vim via ~/.config/github-copilot)

if vim.fn.executable('copilot-language-server') == 0 then
  return
end

-- Keep nvim-lspconfig's on_attach: it defines :LspCopilotSignIn / :LspCopilotSignOut
vim.lsp.config('copilot', {})
vim.lsp.enable('copilot')

-- Ghost-text completion for every client that supports it (only Copilot here)
vim.lsp.inline_completion.enable(true)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('CopilotInlineCompletion', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client:supports_method('textDocument/inlineCompletion', args.buf) then
      return
    end

    local function map(lhs, rhs, desc)
      vim.keymap.set('i', lhs, rhs, { buffer = args.buf, desc = desc })
    end

    -- Same keys as the previous copilot.vim setup
    vim.keymap.set('i', '<C-g>', function()
      if not vim.lsp.inline_completion.get() then
        return '<C-g>'
      end
    end, { buffer = args.buf, expr = true, desc = 'Copilot: accept suggestion' })
    map('<C-j>', function() vim.lsp.inline_completion.select({ count = 1 }) end, 'Copilot: next suggestion')
    map('<C-k>', function() vim.lsp.inline_completion.select({ count = -1 }) end, 'Copilot: previous suggestion')
  end,
})
