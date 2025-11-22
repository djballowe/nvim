return {
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
          cpp = { 'clang-format' },
          sql = { 'sql_formatter' },
          go = { 'gofmt' },
          sh = { 'shfmt' }
        },
        formatters = {
          shfmt = {
            prepend_args = { "-i", "2" }
          }
        }
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
}
