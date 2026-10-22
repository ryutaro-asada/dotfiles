-- Treesitter configuration (nvim-treesitter `main` branch, Neovim 0.12+)
--
-- The `main` branch is a full rewrite: there is no `configs.setup{ highlight=..., indent=... }`
-- anymore. The plugin only installs parsers/queries; features are enabled per buffer
-- via Neovim's built-in APIs (vim.treesitter.start, indentexpr).
-- Requires: tree-sitter CLI >= 0.26.1, curl, tar, a C compiler.

local ensure_installed = {
  'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx',
  'javascript', 'typescript', 'vimdoc', 'vim', 'bash',
  'ruby', 'terraform', 'markdown', 'make', 'hcl', 'vue',
}

-- Languages that keep regex (vim syntax) highlighting alongside treesitter
local regex_highlight = { ruby = true }
-- Languages where treesitter indentation is disabled
local indent_disabled = { ruby = true }

local function enable_features(buf, lang)
  if not pcall(vim.treesitter.start, buf, lang) then
    return false
  end
  if regex_highlight[lang] then
    vim.bo[buf].syntax = 'on'
  end
  if not indent_disabled[lang] then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
  return true
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- main branch does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')
      ts.setup {}
      ts.install(ensure_installed) -- async, no-op if already installed

      local available = {}
      for _, lang in ipairs(ts.get_available()) do
        available[lang] = true
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang or enable_features(args.buf, lang) then
            return
          end
          -- Equivalent of the old `auto_install = true`
          if available[lang] and not vim.list_contains(ts.get_installed(), lang) then
            ts.install({ lang }):await(function()
              if vim.api.nvim_buf_is_valid(args.buf) then
                enable_features(args.buf, lang)
              end
            end)
          end
        end,
      })

      -- Incremental selection: replaced by Neovim 0.12 built-ins (v_an / v_in).
      vim.keymap.set('n', '<C-space>', 'van', { remap = true, desc = 'Start treesitter selection' })
      vim.keymap.set('x', '<C-space>', 'an', { remap = true, desc = 'Expand treesitter selection' })
      vim.keymap.set('x', '<M-space>', 'in', { remap = true, desc = 'Shrink treesitter selection' })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    init = function()
      -- Built-in ftplugins (python, ruby, rust, ...) define their own ]m/[m etc.
      -- which would shadow the mappings below.
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      local select = require('nvim-treesitter-textobjects.select')
      local move = require('nvim-treesitter-textobjects.move')
      local swap = require('nvim-treesitter-textobjects.swap')

      -- Select
      local selects = {
        aa = '@parameter.outer',
        ia = '@parameter.inner',
        af = '@function.outer',
        ['if'] = '@function.inner',
        ac = '@class.outer',
        ic = '@class.inner',
      }
      for lhs, obj in pairs(selects) do
        vim.keymap.set({ 'x', 'o' }, lhs, function()
          select.select_textobject(obj, 'textobjects')
        end, { desc = 'Select ' .. obj })
      end

      -- Move
      local moves = {
        { ']m', 'goto_next_start', '@function.outer' },
        { ']]', 'goto_next_start', '@class.outer' },
        { ']M', 'goto_next_end', '@function.outer' },
        { '][', 'goto_next_end', '@class.outer' },
        { '[m', 'goto_previous_start', '@function.outer' },
        { '[[', 'goto_previous_start', '@class.outer' },
        { '[M', 'goto_previous_end', '@function.outer' },
        { '[]', 'goto_previous_end', '@class.outer' },
      }
      for _, m in ipairs(moves) do
        local lhs, fn, obj = m[1], m[2], m[3]
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
          move[fn](obj, 'textobjects')
        end, { desc = fn .. ' ' .. obj })
      end

      -- Swap
      vim.keymap.set('n', '<leader>xa', function()
        swap.swap_next('@parameter.inner')
      end, { desc = 'Swap with next parameter' })
      vim.keymap.set('n', '<leader>xA', function()
        swap.swap_previous('@parameter.inner')
      end, { desc = 'Swap with previous parameter' })
    end,
  },
}
