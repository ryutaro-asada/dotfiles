-- Keymaps configuration
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Leader key is set in options.lua

-- Disable space in normal and visual mode (leader key)
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- ===========================
-- Normal mode
-- ===========================

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Window exchange
vim.api.nvim_set_keymap('n', '<leader>xx', '<C-w>x', { desc = 'exchange next window' })

-- Do not yank with x
keymap("n", "x", '"_x', opts)

-- Move to line start/end
keymap("n", "<Space>h", "^", opts)
keymap("n", "<Space>l", "$", opts)

-- Clear search highlight
keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts)

-- Better j/k navigation (respect wrapped lines)
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Tab navigation
keymap("n", "tp", "gT", opts)
keymap("n", "tn", "gt", opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end,
  { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end,
  { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- LSP keymaps (buffer-local LSP maps like <leader>ca live in lua/lsp/init.lua)
vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format, { desc = 'Format current buffer' })

-- File operations
vim.keymap.set('n', '<leader>cf', "<cmd>! echo %<CR>", { desc = 'show [C]urrent [F]ile' })

-- Reload buffer
vim.keymap.set('n', '<leader>ll', function()
  vim.cmd('e')
end, { noremap = true, silent = true })

-- Copy current file relative path to clipboard
vim.keymap.set('n', 'Y', function()
  local filepath = vim.fn.expand('%')
  vim.fn.setreg('+', filepath)
  vim.notify('Copied relative path: ' .. filepath)
end, { desc = 'Copy current relative file path to clipboard' })

-- ===========================
-- Insert mode
-- ===========================

-- Quick escape to normal mode
vim.keymap.set('i', 'kk', '<ESC>', { silent = true })

-- ===========================
-- Visual mode
-- ===========================

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Select to end of line with v
keymap("v", "v", "$h", opts)

-- Paste from 0 register
keymap("v", "<C-p>", '"0p', opts)

-- ===========================
-- Terminal mode
-- ===========================

-- Quick escape from terminal mode
keymap('t', 'kk', "<C-\\><C-n>", opts)

-- ===========================
-- Telescope keymaps
-- ===========================
-- Note: These are defined here but will only work after Telescope is loaded

vim.keymap.set('n', '<leader>?', function()
  require('telescope.builtin').oldfiles()
end, { desc = '[?] Find recently opened files' })

vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>s/', function()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>sg', function()
  require('telescope.builtin').git_status()
end, { desc = 'Search [G]it [F]iles' })

vim.keymap.set('n', '<leader>sf', function()
  require('telescope.builtin').find_files()
end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>st', function()
  require('telescope.builtin').live_grep()
end, { desc = '[S]earch by [G]rep' })

vim.keymap.set('n', '<leader>sb', function()
  require('telescope.builtin').buffers()
end, { desc = '[S]earch by [B]uffers' })

vim.keymap.set('n', '<leader>sh', function()
  require('telescope.builtin').search_history()
end, { desc = '[S]earch by [H]istory' })

vim.keymap.set('n', "<leader>sd", function()
  require("telescope").extensions.dir.live_grep()
end, { desc = '[S]earch by grep in selected [D]ir' })

vim.keymap.set('n', "<leader>sm", "<cmd>Telescope terraform_doc full_name=hashicorp/aws version=6.50.0<CR>",
  { desc = '[S]earch Terrafor[M]' })

-- ===========================
-- Copilot keymaps
-- ===========================

vim.keymap.set(
  "i",
  "<C-g>",
  'copilot#Accept("<CR>")',
  { silent = true, expr = true, script = true, replace_keycodes = false }
)
vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)")
vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)")
vim.keymap.set("i", "<C-d>", "<Plug>(copilot-dismiss)")
vim.keymap.set("i", "<C-s>", "<Plug>(copilot-suggest)")

-- ===========================
-- Git linker keymaps
-- ===========================

vim.keymap.set('n', '<leader>gB', function()
  require "gitlinker".get_buf_range_url("n", { action_callback = require "gitlinker.actions".open_in_browser })
end, { silent = true, desc = 'Open Git link in browser' })

vim.keymap.set('v', '<leader>gB', function()
  require "gitlinker".get_buf_range_url("v", { action_callback = require "gitlinker.actions".open_in_browser })
end, { desc = 'Open Git link in browser' })

-- Copy git file path with line range (visual mode)
-- Create user command to handle range properly
vim.api.nvim_create_user_command('CopyGitLineRange', function(args)
  local start_line = args.line1
  local end_line = args.line2

  -- Find git root
  local current_file = vim.fn.expand('%:p')
  local current_dir = vim.fn.fnamemodify(current_file, ':h')
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]

  if vim.v.shell_error ~= 0 then
    vim.notify('Not a git repository', vim.log.levels.ERROR)
    return
  end

  -- Calculate relative path from git root
  local relative_path
  if current_file:sub(1, #git_root) == git_root then
    relative_path = current_file:sub(#git_root + 2)
  else
    relative_path = vim.fn.fnamemodify(current_file, ':~:.')
  end

  -- Format: path/to/file.ext#L<start>-<end>
  local result = string.format('%s#L%d-%d', relative_path, start_line, end_line)

  -- Copy to clipboard
  vim.fn.setreg('+', result)
  vim.notify('Copied! ' .. result, vim.log.levels.INFO)
end, { range = true, desc = 'Copy git file path with line range' })

-- Keymap to invoke the command
vim.keymap.set('v', '<leader>gl', ':CopyGitLineRange<CR>', { desc = 'Copy [g]it file path with [l]ine range' })

-- ===========================
-- partial-diff keymaps
-- ===========================

-- Mark the visual selection as the source range (diff "from").
vim.keymap.set('v', '<leader>df', ':PartialDiffFrom<CR>', { desc = 'Partial [D]iff: mark [F]rom range' })
-- Mark the visual selection as the target range and open the diff ("to").
vim.keymap.set('v', '<leader>dt', ':PartialDiffTo<CR>', { desc = 'Partial [D]iff: mark [T]o range and diff' })
-- Close the current partial diff view.
vim.keymap.set('n', '<leader>dd', ':PartialDiffDelete<CR>', { desc = 'Partial [D]iff: [D]elete/close view' })
