-- LSP server configurations

local lsp_common = require('lsp')

-- Lua LSP
vim.lsp.config('lua_ls', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    }
  }
})
vim.lsp.enable('lua_ls')

-- Go LSP
vim.lsp.config('gopls', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})
vim.lsp.enable('gopls')

-- Ruby LSP
vim.lsp.config('ruby_lsp', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
})
vim.lsp.enable('ruby_lsp')

-- Terraform LSP
vim.lsp.config('terraformls', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
})
vim.lsp.enable('terraformls')

-- Zig LSP
vim.lsp.config('zls', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
})
vim.lsp.enable('zls')

-- C/C++ LSP
vim.lsp.config('clangd', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
})
vim.lsp.enable('clangd')

-- HTML LSP
vim.lsp.config('html', {
  capabilities = lsp_common.capabilities_html,
  on_attach = lsp_common.on_attach,
})
vim.lsp.enable('html')

-- JSON LSP
vim.lsp.config('jsonls', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
})
vim.lsp.enable('jsonls')

-- YAML LSP
vim.lsp.config('yamlls', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
})
vim.lsp.enable('yamlls')

-- Dockerfile LSP
vim.lsp.config('dockerls', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
})
vim.lsp.enable('dockerls')

-- Python LSP
vim.lsp.config('pylsp', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
  settings = {
    pylsp = {
      plugins = {
        black = {
          enabled = true,
          line_length = 100,
          ignore = { 'E501' },
        },
        flake8 = {
          ignore = { 'E501' },
        },
        pycodestyle = {
          ignore = { 'E501' },
        },
      }
    }
  }
})
vim.lsp.enable('pylsp')

-- Markdown LSP
vim.lsp.config('marksman', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
})
vim.lsp.enable('marksman')

-- Bash LSP
vim.lsp.config('bashls', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
})
vim.lsp.enable('bashls')

-- Autotools LSP
vim.lsp.config('autotools_ls', {
  capabilities = lsp_common.capabilities,
  on_attach = lsp_common.on_attach,
})
vim.lsp.enable('autotools_ls')

-- Rust Analyzer
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false,
      }
    }
  }
})
vim.lsp.enable('rust_analyzer')

-- TypeScript/JavaScript LSP
vim.lsp.config('ts_ls', {
  on_attach = lsp_common.on_attach,
})
vim.lsp.enable('ts_ls')

-- ESLint LSP with auto-fix on save
local base_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config("eslint", {
  on_attach = function(client, bufnr)
    if not base_on_attach then return end

    base_on_attach(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "LspEslintFixAll",
    })
  end,
})
vim.lsp.enable('eslint')
