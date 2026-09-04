return {
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
  {
    'sindrets/diffview.nvim',
    cmd = {
      'DiffviewClose',
      'DiffviewFileHistory',
      'DiffviewFocusFiles',
      'DiffviewLog',
      'DiffviewOpen',
      'DiffviewRefresh',
      'DiffviewToggleFiles',
    },
    keys = {
      { '<leader>dc', '<cmd>DiffviewClose<cr>', desc = 'Close Diffview' },
    },
  },
  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    opts = {},
    keys = {
      {
        '<leader>go',
        function()
          require('neogit').open { kind = 'split_above_all' }
        end,
        desc = 'Open Neogit',
      },
      { '<leader>gb', '<cmd>Neogit branch<cr>', desc = 'Neogit branches' },
      { '<leader>gm', '<cmd>Neogit commit<cr>', desc = 'Neogit commit' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end

          vim.schedule(function()
            gitsigns.nav_hunk 'next'
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next git hunk' })

        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end

          vim.schedule(function()
            gitsigns.nav_hunk 'prev'
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous git hunk' })
      end,
    },
  },
}
