-- [[ for nvim-tree ]]
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- language en_US
vim.cmd("language en_US.utf-8")

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
require('config.keymaps')


-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = false

-- Enable mouse mode
vim.o.mouse = 'a'





-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 310

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
-- vim.o.termguicolors = true

vim.o.autochdir = false
vim.o.number = true

-- no wrap lines
vim.o.wrap = false



-- [[ Keymaps
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format, { desc = 'Format current buffer' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
-- vim.keymap.set('n', '<leader>ca', vim.lsp.codelens.run(), { desc = '[C]ode [A]ction' })


--
vim.keymap.set('i', 'kk', '<ESC>', { silent = true })
-- vim.keymap.set( 'v', 'aa', '<ESC>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>xx', '<C-w>x', { desc = 'exchange next window' })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').git_status, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>st', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch by [B]uffers' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').search_history, { desc = '[S]earch by [H]istory' })

vim.keymap.set('n', "<leader>sd", require("telescope").extensions.dir.live_grep,
  { desc = '[S]earch by grep in selected [D]ir' })
-- Telescope terraform_doc full_name=hashicorp/aws version=4.67.0
vim.keymap.set('n', "<leader>sm", "<cmd>Telescope terraform_doc full_name=hashicorp/aws version=5.54.1<CR>",
  { desc = '[S]earch Terrafor[M]' })

vim.keymap.set('n', "<leader>cf", "<cmd>! echo %<CR>", { desc = 'show [C]urrent [F]ile' })
vim.keymap.set('n', "<leader>cw", vim.fn.getcwd(), { desc = 'show [C]urrent [W]ork dir' })
local keyopts = { noremap = true, silent = true }
local key_map = vim.api.nvim_set_keymap
key_map("n", "tp", "gT", keyopts)
key_map("n", "tn", "gt", keyopts)
local keymap = vim.keymap.set
-- https://github.com/orgs/community/discussions/29817#discussioncomment-4217615
keymap(
  "i",
  "<C-g>",
  'copilot#Accept("<CR>")',
  { silent = true, expr = true, script = true, replace_keycodes = false }
)
keymap("i", "<C-j>", "<Plug>(copilot-next)")
keymap("i", "<C-k>", "<Plug>(copilot-previous)")
keymap("i", "<C-d>", "<Plug>(copilot-dismiss)")
keymap("i", "<C-s>", "<Plug>(copilot-suggest)")

-- gitlinker
vim.api.nvim_set_keymap('n', '<leader>gB',
  '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
  { silent = true })
vim.api.nvim_set_keymap('v', '<leader>gB',
  '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
  {})



-- ]]


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      '^node_modules/',
      '^local_modules/',
      'lock$',
      'svg$',
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      '--hidden', -- not ignore dotfiles
    },
  },
  -- ref: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#mapping-c-d-to-delete-buffer
  pickers = {
    live_grep = {
      -- live_grepの結果数を増やす
      max_results = 1000, -- 結果の最大数を設定
    },
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      theme = "dropdown",
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        }
      }
    }
  },
}



-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
require('telescope').load_extension('terraform_doc')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})


-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'ruby', 'terraform', 'markdown', 'make', 'hcl', 'vue' },
    sync_install = true,
    ignore_install = {},
    modules = {
    },


    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,
    highlight = {},
    -- highlight = {
    --   enable = true,
    --   disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --       return true
    --     end
    --   end,
    -- },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          ['[m'] = '@function.outer', [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[M'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          [']M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
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

-- -- document existing key chains
-- require('which-key').register {
--   ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
--   ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
--   -- ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
--   ['<leader>g'] = { name = '[G]it Hunk', _ = 'which_key_ignore' },
--   ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
--   ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
--   ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
--   ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
-- }
-- document existing key chains
require('which-key').add({
  { "<leader>c", desc = "[C]ode" },
  -- Optional: if <leader>c itself doesn't have an action,
  -- and you only have mappings like <leader>ca, <leader>cb, etc.
  -- you might add this to prevent <leader>c from showing as a "missing" mapping if you type it slowly.
  -- { "<leader>c_", hidden = true, desc = "Code desc placeholder" },

  { "<leader>d", desc = "[D]ocument" },
  -- { "<leader>d_", hidden = true, desc = "Document desc placeholder" },

  { "<leader>g", desc = "[G]it Hunk" }, -- Assuming you prefer "[G]it Hunk" over "[G]it"
  -- { "<leader>g_", hidden = true, desc = "Git Hunk desc placeholder" },

  { "<leader>r", desc = "[R]ename" },
  -- { "<leader>r_", hidden = true, desc = "Rename desc placeholder" },

  { "<leader>s", desc = "[S]earch" },
  -- { "<leader>s_", hidden = true, desc = "Search desc placeholder" },

  { "<leader>t", desc = "[T]oggle" },
  -- { "<leader>t_", hidden = true, desc = "Toggle desc placeholder" },

  { "<leader>w", desc = "[W]orkspace" },
  -- { "<leader>w_", hidden = true, desc = "Workspace group placeholder" },
})

-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
-- require('which-key').register({
--   ['<leader>'] = { name = 'VISUAL <leader>' },
--   ['<leader>g'] = { '[G]it Hunk' },
-- }, { mode = 'v' })

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
-- require('mason').setup()
-- require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
-- html lsp
--Enable (broadcasting) snippet capability for completion
local capabilities_html = vim.lsp.protocol.make_client_capabilities()
capabilities_html.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup neovim lua configuration
-- require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())


-- Neovim 0.11+ Native LSP Configuration
-- show diagnostics in virtual text
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- Lua LSP
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    }
  }
})
vim.lsp.enable('lua_ls')

-- Go LSP
vim.lsp.config('gopls', {
  capabilities = capabilities,
  on_attach = on_attach,
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
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.enable('ruby_lsp')

-- Terraform LSP
vim.lsp.config('terraformls', {
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.enable('terraformls')

-- Zig LSP
vim.lsp.config('zls', {
  capabilities = capabilities,
  on_attach = on_attach,
  -- settings = {
  --   zls = {
  --     zigPath = 'zig', -- Adjust this if your zig binary is in a different location
  --     enableExperimentalFeatures = true, -- Enable experimental features if needed
  --   }
  -- }
})
vim.lsp.enable('zls')

-- C/C++ LSP
vim.lsp.config('clangd', {
  capabilities = capabilities,
  on_attach = on_attach,
  -- cmd = { 'clangd', '--background-index' },
})
vim.lsp.enable('clangd')

-- -- HTML LSP
vim.lsp.config('html', {
  capabilities = capabilities_html,
  on_attach = on_attach,
})
vim.lsp.enable('html')
--
-- JSON LSP
vim.lsp.config('jsonls', {
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.enable('jsonls')

-- YAML LSP
vim.lsp.config('yamlls', {
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.enable('yamlls')

-- Dockerfile LSP
vim.lsp.config('dockerls', {
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.enable('dockerls')


-- Python LSP
vim.lsp.config('pylsp', {
  capabilities = capabilities,
  on_attach = on_attach,
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
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.enable('marksman')

-- bash lsp
vim.lsp.config('bashls', {
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.enable('bashls')

-- autotools lsp
vim.lsp.config('autotools_ls', {
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.enable('autotools_ls')

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

vim.lsp.config('ts_ls', {
  on_attach = on_attach,
})
vim.lsp.enable('ts_ls')

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


-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}



local set_options = {
  hlsearch = true,
}
for k, v in pairs(set_options) do
  vim.opt[k] = v
end

vim.opt.swapfile = false


-- [[ Configure colorscheme ]]
-- color because comment color is good.
-- vim.cmd [[colorscheme desert]]
vim.cmd [[colorscheme gruvbox]]

-- [[ Configure nvim-tree ]]
-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

vim.g.copilot_no_tab_map = true

vim.cmd([[
  autocmd BufWritePre *.sh silent! lua FormatShellScript()
]])

function FormatShellScript()
  local current_file = vim.fn.expand('%:p')
  vim.fn.system(string.format('shfmt -w %s', current_file))
  vim.cmd('edit')
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- for eslint
-- https://neovim.discourse.group/t/how-can-i-setup-eslint-to-format-on-save/2570/5
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
  command = 'silent! EslintFixAll',
  group = vim.api.nvim_create_augroup('MyAutocmdsJavaScripFormatting', {}),
})

require("quicker").setup({
  keys = {
    {
      ">",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      end,
      desc = "Expand quickfix context",
    },
    {
      "<",
      function()
        require("quicker").collapse()
      end,
      desc = "Collapse quickfix context",
    },
  },
})

-- [[ Configure copilot ]]
vim.g.copilot_settings = { selectedCompletionModel = 'gpt-4o-copilot-2025-04-03' }

vim.keymap.set('n', '<leader>ll', function()
  vim.cmd('e')
end, { noremap = true, silent = true })

-- 相対パスをコピーしたい場合は以下を使用
vim.keymap.set('n', 'Y', function()
  local filepath = vim.fn.expand('%')
  vim.fn.setreg('+', filepath)
  vim.notify('Copied relative path: ' .. filepath)
end, { desc = 'Copy current relative file path to clipboard' })


-- -- RSpec実行のキーマッピング設定
-- -- init.lua または適切な設定ファイルに追加してください
-- -- RSpecを実行する関数
-- local function run_rspec_current_file()
--   -- 現在のファイルパスを取得
--   local current_file = vim.fn.expand('%')
--
--   -- ファイルが存在するかチェック
--   if current_file == '' then
--     print('No file is currently open')
--     return
--   end
--
--   -- RSpecコマンドを構築
--   local cmd = string.format('docker compose exec -ti rails bundle exec rspec %s', current_file)
--
--   -- ターミナルでコマンドを実行
--   vim.cmd('split | terminal ' .. cmd)
-- end
--
-- -- RSpecで現在行のテストを実行する関数
-- local function run_rspec_current_line()
--   -- 現在のファイルの相対パスを取得
--   local current_file = vim.fn.expand('%')
--
--   -- ファイルが存在するかチェック
--   if current_file == '' then
--     print('No file is currently open')
--     return
--   end
--
--   -- 現在の行番号を取得
--   local current_line = vim.fn.line('.')
--
--   -- RSpecコマンドを構築（相対パス:行番号を使用）
--   local cmd = string.format('docker compose exec -ti rails bundle exec rspec %s:%d', current_file, current_line)
--
--   -- ターミナルでコマンドを実行
--   vim.cmd('split | terminal ' .. cmd)
-- end
--
-- -- キーマッピングを設定
-- vim.keymap.set('n', '<leader>tt', run_rspec_current_file, {
--   desc = 'Run RSpec for current file',
--   noremap = true,
--   silent = true
-- })
-- vim.keymap.set('n', '<leader>tl', run_rspec_current_line, {
--   desc = 'Run RSpec for current line',
--   noremap = true,
--   silent = true
-- })

-- syntax off

require('partial-diff').setup({
  -- デバッグオプション
  debug = false,

  -- ハイライトのカスタマイズ
  highlights = {
    -- 既存のハイライトグループにリンク
    line_change = 'DiffChange',
    line_add = 'DiffAdd',
    line_delete = 'DiffDelete',

    -- カスタム色を指定
    char_add = {
      bg = '#2d5a2d',   -- 背景色
      fg = '#a9dc76',   -- 文字色
      bold = true,      -- 太字
      italic = false,   -- イタリック
      underline = false -- 下線
    },
    char_delete = {
      bg = '#5a2d2d',
      fg = '#ff6188',
    },
    char_change = {
      bg = '#4a4a0e',
      fg = '#ffd866',
      bold = true
    }
  }
})

-- require("neotest").setup({
--   adapters = {
--     require("neotest-go")({
--       command = "docker",
--       args = { "exec", "-it", "nhk-world-cms-dev-env", "go", "test" },
--       experimental = { test_table = true },
--       recursive_run = true,
--     }),
--   },
--   -- output = { open_on_run = true },
-- })

-- vim.keymap.set("n", "<leader>tl", function()
--   require("neotest").run.run() -- nearest test
-- end)


vim.keymap.set("n", "<leader>tt", function()
  require('neotest').run.run(vim.fn.expand('%'))
end)
