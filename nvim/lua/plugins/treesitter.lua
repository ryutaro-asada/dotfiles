-- Treesitter configuration

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  dependencies = {
    -- Required for the `textobjects` section below (was configured but never installed)
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'master' },
  },
  opts = {
    ensure_installed = {
      'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx',
      'javascript', 'typescript', 'vimdoc', 'vim', 'bash',
      'ruby', 'terraform', 'markdown', 'make', 'hcl', 'vue'
    },
    sync_install = false,
    ignore_install = {},
    modules = {},
    auto_install = true,

    -- Highlight configuration
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },

    -- Indentation
    indent = {
      enable = true,
      disable = { 'ruby' },
    },

    -- Incremental selection
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },

    -- Text objects
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
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
        set_jumps = true,
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>xa'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>xA'] = '@parameter.inner',
        },
      },
    },
  },
}
