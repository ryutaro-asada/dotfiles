-- Auto commands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
local highlight_group = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Format shell scripts on save with shfmt
autocmd('BufWritePre', {
  pattern = '*.sh',
  callback = function()
    local current_file = vim.fn.expand('%:p')
    vim.fn.system(string.format('shfmt -w %s', current_file))
    vim.cmd('edit')
  end,
})

-- ESLint auto-fix on save for JavaScript/TypeScript files
autocmd('BufWritePre', {
  pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
  command = 'silent! EslintFixAll',
  group = augroup('MyAutocmdsJavaScripFormatting', {}),
})
