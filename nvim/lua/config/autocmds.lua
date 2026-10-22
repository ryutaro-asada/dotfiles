-- Auto commands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
local highlight_group = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Format shell scripts on save with shfmt.
-- Pipes the buffer contents through shfmt and replaces them before writing,
-- so the formatted text is what gets saved (no reload, no lost edits).
autocmd('BufWritePre', {
  pattern = '*.sh',
  group = augroup('ShfmtOnSave', { clear = true }),
  callback = function(args)
    if vim.fn.executable('shfmt') == 0 then
      return
    end
    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
    local result = vim.system({ 'shfmt', '-filename', args.file }, { stdin = lines }):wait()
    if result.code ~= 0 then
      vim.notify('shfmt: ' .. (result.stderr or ''), vim.log.levels.WARN)
      return
    end
    local formatted = vim.split(result.stdout, '\n', { plain = true })
    if formatted[#formatted] == '' then
      table.remove(formatted)
    end
    if not vim.deep_equal(lines, formatted) then
      local view = vim.fn.winsaveview()
      vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, formatted)
      vim.fn.winrestview(view)
    end
  end,
})

-- ESLint auto-fix on save is set up in lua/lsp/servers.lua (LspEslintFixAll on attach).
