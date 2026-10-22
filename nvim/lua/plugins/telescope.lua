-- Telescope (fuzzy finder)
-- Configured inside the lazy.nvim spec so setup runs after the plugin is loaded.

-- Helper function to find git root directory
local function find_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()

  if current_file == '' then
    current_dir = cwd
  else
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

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

return {
  {
    'nvim-telescope/telescope.nvim',
    -- 0.1.x is frozen (May 2024) and predates the Neovim 0.12 treesitter API changes
    branch = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'ANGkeith/telescope-terraform-doc.nvim',
      'princejoogie/dir-telescope.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
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
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden', -- not ignore dotfiles
          },
        },
        pickers = {
          live_grep = {
            max_results = 1000,
          },
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            theme = 'dropdown',
            previewer = false,
            mappings = {
              i = {
                ['<c-d>'] = 'delete_buffer',
              },
            },
          },
        },
      }

      -- Enable telescope extensions
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'terraform_doc')

      vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
    end,
  },
}
