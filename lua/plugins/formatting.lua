return {
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      formatters_by_ft = {
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'yamlfmt' },
        markdown = { 'prettier' },
        graphql = { 'prettier' },
        astro = { 'prettier' },
        lua = { 'stylua' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        sql = { 'sql_formatter' },
        go = { 'gofmt' },
        sh = { 'shfmt' },
        rust = { 'rustfmt' },
      },
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
      },
    },
    keys = {
      {
        '<leader>mp',
        function()
          require('conform').format {
            lsp_format = 'fallback',
            async = false,
            timeout_ms = 500,
          }
        end,
        mode = { 'n', 'v' },
        desc = 'Format file or selection',
      },
    },
  },
}
