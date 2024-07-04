-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
    },
    config = function()
      require('telescope').setup {
        -- the rest of your telescope config goes here
        extensions = {
          undo = {
            side_by_side = true,
            layout_strategy = 'vertical',
            layout_config = {
              preview_height = 0.8,
            },
          },
          -- other extensions:
          -- file_browser = { ... }
        },
      }
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {}
      vim.api.nvim_set_keymap('n', '<leader>f', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>ct', ':NvimTreeCollapse<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local conform = require 'conform'
      conform.setup {
        formatters_by_ft = {
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescriptreact = { 'prettier' },
          css = { 'prettier' },
          html = { 'prettier' },
          json = { 'prettier' },
          yaml = { 'prettier' },
          markdown = { 'prettier' },
          graphql = { 'prettier' },
          lua = { 'stylua' },
          c = { 'clang-format' },
        },
      }
      vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
        conform.format {
          lsp_fallback = true,

          async = false,
          timeout_ms = 500,
        }
      end)
    end,
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    cmd = "Trouble",
    keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    }
    }
  },
  {
    'mbbill/undotree',
    vim.api.nvim_set_keymap('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true, silent = true })
  }
}
