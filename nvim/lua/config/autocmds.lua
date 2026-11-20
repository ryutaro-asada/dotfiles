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

-- Restore the cursor to where it was when the file was last closed.
-- Only on read, so revisiting a buffer does not jump again.
autocmd('BufReadPost', {
  group = augroup('LastPosition', { clear = true }),
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if vim.bo[args.buf].buftype ~= '' or ft == 'gitcommit' or ft == 'gitrebase' then
      return
    end
    -- A line was given on the command line (nvim file +num)
    if vim.fn.line('.') > 1 then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      vim.cmd.normal({ 'g`"zz', bang = true })
    end
  end,
})

-- Make files with a shebang executable on save.
autocmd('BufWritePost', {
  group = augroup('ShebangExecutable', { clear = true }),
  callback = function(args)
    local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ''
    if first_line:match('^#!.*/bin/') then
      vim.fn.setfperm(args.file, 'rwxr-xr-x')
    end
  end,
})

local qf_group = augroup('Quickfix', { clear = true })

-- Open the quickfix/location list after :grep, :make and friends.
autocmd('QuickfixCmdPost', {
  group = qf_group,
  pattern = { 'make', 'grep', 'grepadd', 'vimgrep', 'vimgrepadd' },
  command = 'cwindow',
})
autocmd('QuickfixCmdPost', {
  group = qf_group,
  pattern = { 'lmake', 'lgrep', 'lgrepadd', 'lvimgrep', 'lvimgrepadd' },
  command = 'lwindow',
})

-- Pin the quickfix buffer to its window so :bnext/:edit don't replace it.
autocmd({ 'FileType', 'BufWinEnter' }, {
  group = qf_group,
  callback = function(args)
    if vim.bo[args.buf].filetype ~= 'qf' then
      return
    end
    for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
      vim.wo[win].winfixbuf = true
    end
  end,
})

-- Highlight the separators of the current window.
local active_sep = 'WinSeparator:WinSeparatorActive'
local sep_group = augroup('ActiveWinSeparator', { clear = true })
local function set_active_separator_hl()
  vim.api.nvim_set_hl(0, 'WinSeparatorActive', { link = 'Special', default = true })
end
set_active_separator_hl()
autocmd('ColorScheme', { group = sep_group, callback = set_active_separator_hl })
autocmd({ 'WinEnter', 'BufWinEnter', 'VimEnter' }, {
  group = sep_group,
  callback = function()
    local cur = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(win).relative == '' then
        local parts = vim.tbl_filter(function(p)
          return p ~= '' and p ~= active_sep
        end, vim.split(vim.wo[win].winhighlight, ',', { plain = true }))
        if win == cur then
          table.insert(parts, active_sep)
        end
        vim.wo[win].winhighlight = table.concat(parts, ',')
      end
    end
  end,
})

-- ESLint auto-fix on save is set up in lua/lsp/servers.lua (LspEslintFixAll on attach).
