-- LSP server configurations

local lsp_common = require('lsp')

-- ===========================
-- Server definitions
-- ===========================

local servers = {
  -- Simple servers (default config only)
  ruby_lsp = {},
  terraformls = {},
  zls = {},
  clangd = {},
  jsonls = {},
  yamlls = {},
  dockerls = {},
  marksman = {},
  bashls = {},
  autotools_ls = {},

  -- biome と喧嘩するので ts_ls のフォーマッタは無効化
  ts_ls = {
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      lsp_common.on_attach(client, bufnr)
    end,
  },
  biome = {},

  -- Servers with custom settings
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      }
    }
  },

  gopls = {
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },

  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          black = {
            enabled = true,
            line_length = 100,
            ignore = { 'E501' },
          },
          flake8 = { ignore = { 'E501' } },
          pycodestyle = { ignore = { 'E501' } },
        }
      }
    }
  },

  -- HTML (special capabilities)
  html = {
    capabilities = lsp_common.capabilities_html,
  },

  -- Rust Analyzer (diagnostics disabled, no on_attach)
  rust_analyzer = {
    on_attach = vim.NIL, -- vim.NIL will be converted to nil
    settings = {
      ['rust-analyzer'] = {
        diagnostics = { enable = false }
      }
    }
  },
}

-- ===========================
-- Setup all servers
-- ===========================

for name, config in pairs(servers) do
  -- Merge with default config
  local final_config = vim.tbl_deep_extend('force', {
    capabilities = lsp_common.capabilities,
    on_attach = lsp_common.on_attach,
  }, config)

  -- Convert vim.NIL to nil (for explicitly disabling options)
  for k, v in pairs(final_config) do
    if v == vim.NIL then
      final_config[k] = nil
    end
  end

  vim.lsp.config(name, final_config)
  vim.lsp.enable(name)
end

-- ===========================
-- ESLint (special on_attach handling)
-- ===========================

local base_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config('eslint', {
  on_attach = function(client, bufnr)
    if base_on_attach then
      base_on_attach(client, bufnr)
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "LspEslintFixAll",
    })
  end,
})
vim.lsp.enable('eslint')
