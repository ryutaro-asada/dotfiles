-- Plugin specifications
return {
  -- ===========================
  -- Basic plugins
  -- ===========================

  -- Git integration
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- ===========================
  -- LSP
  -- ===========================

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim', opts = {} },
    },
  },

  -- Neovim Lua API types/completion for lua_ls (successor of the archived neodev.nvim)
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- ===========================
  -- Autocompletion: see lua/plugins/cmp.lua
  -- ===========================

  -- ===========================
  -- UI & Navigation
  -- ===========================

  -- Which-key for keybinding hints
  {
    'folke/which-key.nvim',
    opts = {},
    dependencies = {
      'echasnovski/mini.nvim',
    },
  },

  -- GitHub Copilot
  {
    'github/copilot.vim'
  },


  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.nav_hunk('next')
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to next hunk' })

        map({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.nav_hunk('prev')
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to previous hunk' })

        map('n', '[C', function() gs.nav_hunk('first') end, { desc = 'Jump to first hunk' })
        map('n', ']C', function() gs.nav_hunk('last') end, { desc = 'Jump to last hunk' })

        -- All changed hunks in the repo -> quickfix (navigate with :cnext / :cprev)
        map('n', '<leader>gq', function() gs.setqflist('all') end, { desc = 'git hunks (repo) to quickfix' })

        -- Actions
        -- visual mode
        map('v', '<leader>gs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>gr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>gs', gs.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>gr', gs.reset_hunk, { desc = 'git reset hunk' })
        map('n', '<leader>gS', gs.stage_buffer, { desc = 'git Stage buffer' })
        -- stage_hunk on an already-staged hunk unstages it (replaces deprecated undo_stage_hunk)
        map('n', '<leader>gu', gs.stage_hunk, { desc = 'toggle stage hunk' })
        map('n', '<leader>gR', gs.reset_buffer, { desc = 'git Reset buffer' })
        map('n', '<leader>gp', gs.preview_hunk, { desc = 'preview git hunk' })
        map('n', '<leader>gb', function()
          gs.blame_line { full = false }
        end, { desc = 'git blame line' })
        map('n', '<leader>gd', gs.diffthis, { desc = 'git diff against index' })
        map('n', '<leader>gD', function()
          gs.diffthis '~'
        end, { desc = 'git diff against last commit' })

        -- Toggles
        map('n', '<leader>gt', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
        map('n', '<leader>td', gs.preview_hunk_inline, { desc = 'git preview deleted (inline)' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
      end,
    },
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        -- theme = 'onedark',
        theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- ===========================
  -- Telescope (Fuzzy Finder): see lua/plugins/telescope.lua
  -- Treesitter: see lua/plugins/treesitter.lua
  -- ===========================

  -- ===========================
  -- File Explorer
  -- ===========================

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        update_focused_file = {
          enable = true,
          update_cwd = false,
        },
      }
    end,
  },

  -- ===========================
  -- Color Scheme & UI
  -- ===========================

  {
    "ellisonleao/gruvbox.nvim",
  },

  {
    "sainnhe/everforest"
  },

  {
    "nyoom-engineering/oxocarbon.nvim"
  },

  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    -- Published version from GitHub (default branch: main).
    -- PR #3 is merged into main, so the diff.* options and line_move
    -- highlight below are active.
    -- To go back to the local working copy, comment this block and uncomment
    -- the `dir = ...` block below.
    "ryutaro-asada/partial-diff.nvim",
    build = ":PartialDiffInstallVSCode",
    -- Local development checkout:
    -- name = "partial-diff.nvim",
    -- dir = "/Users/asaryu/repos/partial-diff.nvim",
    config = function()
      require('partial-diff').setup({
        debug = false,
        diff = {
          -- Detect moved code blocks and mark them instead of showing a change.
          compute_moves = true,
          -- Set to true to ignore pure indentation / trailing-space changes.
          ignore_trim_whitespace = false,
          -- Keep the two windows scroll/cursor synced.
          sync_scroll = true,
          -- Turn off wrap in both windows so horizontal scroll is mirrored.
          sync_scroll_nowrap = true,
        },
        highlights = {
          line_change = 'DiffChange',
          line_add = 'DiffAdd',
          line_delete = 'DiffDelete',
          char_add = {
            bg = '#2d5a2d',
            fg = '#a9dc76',
            bold = true,
          },
          char_delete = {
            bg = '#5a2d2d',
            fg = '#ff6188',
          },
          char_change = {
            bg = '#4a4a0e',
            fg = '#ffd866',
            bold = true
          },
          -- Highlight for moved blocks (used when diff.compute_moves = true).
          line_move = {
            bg = '#2d3a5a',
            fg = '#78a9ff',
          }
        }
      })
    end,
  },


  -- ===========================
  -- Markdown Preview
  -- ===========================

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- ===========================
  -- Utility Plugins
  -- ===========================

  {
    'stevearc/quicker.nvim',
    event = "FileType qf",
    config = function()
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
    end,
  },
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = " <summary> • <date> • <author> • <<sha>>",
      date_format = "%m-%d-%Y %H:%M:%S",
      virtual_text_column = 1,
    }
  },

  {
    "LunarVim/bigfile.nvim",
  },

  {
    'duggiefresh/vim-easydir',
  },

  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitlinker").setup()
    end,
    lazy = false,
  },

  -- ===========================
  -- AI Assistants
  -- ===========================

  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a",  nil,                              desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    },
  },
}
