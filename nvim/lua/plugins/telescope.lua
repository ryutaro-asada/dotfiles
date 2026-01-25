-- Telescope configuration

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

-- Create user command for git root search
vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- Telescope setup is called after lazy.nvim loads plugins
-- This configuration will be executed after telescope is loaded
local function setup_telescope()
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
    pickers = {
      live_grep = {
        max_results = 1000,
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

  -- Enable telescope extensions
  pcall(require('telescope').load_extension, 'fzf')
  require('telescope').load_extension('terraform_doc')
end

-- Call setup when this module is loaded
setup_telescope()

return {}
