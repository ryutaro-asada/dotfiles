-- LSP common configuration

local M = {}

-- LSP on_attach function
M.on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- Core LSP keymaps
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  -- Navigation (using Telescope when available)
  nmap('gd', function()
    require('telescope.builtin').lsp_definitions()
  end, '[G]oto [D]efinition')

  -- nowait: Neovim 0.11+ has default global gr* maps (grn, gra, grr, gri, grt, grx);
  -- without it `gr` would pause for 'timeoutlen' waiting for a second key.
  vim.keymap.set('n', 'gr', function()
    require('telescope.builtin').lsp_references()
  end, { buffer = bufnr, nowait = true, desc = 'LSP: [G]oto [R]eferences' })

  nmap('gI', function()
    require('telescope.builtin').lsp_implementations()
  end, '[G]oto [I]mplementation')

  nmap('<leader>D', function()
    require('telescope.builtin').lsp_type_definitions()
  end, 'Type [D]efinition')

  nmap('<leader>ds', function()
    require('telescope.builtin').lsp_document_symbols()
  end, '[D]ocument [S]ymbols')

  nmap('<leader>ws', function()
    require('telescope.builtin').lsp_dynamic_workspace_symbols()
  end, '[W]orkspace [S]ymbols')

  -- Documentation
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- Less commonly used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Setup LSP capabilities for autocompletion
M.capabilities = require('cmp_nvim_lsp').default_capabilities()

-- HTML LSP needs special capabilities
M.capabilities_html = vim.lsp.protocol.make_client_capabilities()
M.capabilities_html.textDocument.completion.completionItem.snippetSupport = true

-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- Document existing which-key chains
require('which-key').add({
  { "<leader>c", desc = "[C]ode" },
  { "<leader>d", desc = "[D]ocument" },
  { "<leader>g", desc = "[G]it Hunk" },
  { "<leader>r", desc = "[R]ename" },
  { "<leader>s", desc = "[S]earch" },
  { "<leader>t", desc = "[T]oggle" },
  { "<leader>w", desc = "[W]orkspace" },
})

return M
