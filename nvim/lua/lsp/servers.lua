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

  -- Rust Analyzer (diagnostics disabled; keymaps come from the common on_attach)
  rust_analyzer = {
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

-- Returns true if the server's command is available on $PATH.
-- Enabling a server whose binary is missing makes Neovim log/notify
-- "cannot start <name> due to config error" every time a matching file opens.
local function is_installed(name)
  local cmd = (vim.lsp.config[name] or {}).cmd
  if type(cmd) == 'table' and cmd[1] then
    return vim.fn.executable(cmd[1]) == 1
  end
  return true -- cmd is a function (or unset): let Neovim decide
end

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
  if is_installed(name) then
    vim.lsp.enable(name)
  end
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

    -- Per-buffer group so re-attaching doesn't stack duplicate autocmds
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup('EslintFixAll_' .. bufnr, { clear = true }),
      buffer = bufnr,
      command = "LspEslintFixAll",
    })
  end,
})
if is_installed('eslint') then
  vim.lsp.enable('eslint')
end

-- ===========================
-- GitHub Copilot (inline completion + NES)
-- ===========================

require('lsp.copilot')
