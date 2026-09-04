return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local attach_group = vim.api.nvim_create_augroup('LspAttachConfig', { clear = true })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = attach_group,
        callback = function(event)
          local function nmap(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          nmap('gd', require('telescope.builtin').lsp_definitions, 'Goto definition')
          nmap('gr', require('telescope.builtin').lsp_references, 'Goto references')
          nmap('gI', require('telescope.builtin').lsp_implementations, 'Goto implementation')
          nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type definition')
          nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document symbols')
          nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace symbols')
          nmap('K', vim.lsp.buf.hover, 'Hover documentation')
          nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')
          nmap('gD', vim.lsp.buf.declaration, 'Goto declaration')
          nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd folder')
          nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove folder')
          nmap('<leader>wl', function()
            vim.print(vim.lsp.buf.list_workspace_folders())
          end, '[W]orkspace [L]ist folders')

          vim.api.nvim_buf_create_user_command(event.buf, 'Format', function()
            vim.lsp.buf.format()
          end, {
            desc = 'Format current buffer with LSP',
            force = true,
          })
        end,
        desc = 'Create buffer-local LSP mappings and commands',
      })

      vim.keymap.set('n', '<leader>lr', '<cmd>lsp restart<cr>', { desc = 'Restart LSP clients' })

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local servers = {
        bashls = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      }

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_enable = false,
      }

      for server_name, server_config in pairs(servers) do
        server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})
        vim.lsp.config(server_name, server_config)
        vim.lsp.enable(server_name)
      end
    end,
  },
}
