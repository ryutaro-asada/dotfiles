return {
  {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      picker = 'telescope',
      -- Open the right side of a review as the checked-out local file so LSP attaches.
      use_local_fs = true,
    },
    config = function(_, opts)
      require('octo').setup(opts)
      -- octo marks every review buffer nomodifiable, including the local file
      -- it opens on the right with use_local_fs. Re-enable editing for that
      -- one; octo:// buffers hold GitHub content and stay read-only.
      vim.api.nvim_create_autocmd('BufWinEnter', {
        group = vim.api.nvim_create_augroup('octo_local_fs_editable', { clear = true }),
        callback = function(args)
          local ok, props = pcall(vim.api.nvim_buf_get_var, args.buf, 'octo_diff_props')
          if ok and props.split == 'RIGHT' and not args.file:match('^octo://') then
            vim.bo[args.buf].modifiable = true
          end
        end,
      })
    end,
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    opts = {
      -- Open the HEAD side of a range like origin/develop...HEAD as the local
      -- file instead of a git blob, so LSP attaches there.
      default_args = {
        DiffviewOpen = { '--imply-local' },
      },
    },
  },
}
