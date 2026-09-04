local parsers = {
  'bash',
  'c',
  'cpp',
  'go',
  'graphql',
  'javascript',
  'json',
  'lua',
  'python',
  'rust',
  'scss',
  'sql',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'vue',
}

local function attach_parser(bufnr, language)
  if not vim.treesitter.language.add(language) then
    return
  end

  vim.treesitter.start(bufnr, language)

  if vim.treesitter.query.get(language, 'indents') then
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local treesitter = require 'nvim-treesitter'

      treesitter.install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreesitterAttach', { clear = true }),
        callback = function(event)
          local language = vim.treesitter.language.get_lang(event.match)
          if not language then
            return
          end

          local installed_parsers = treesitter.get_installed 'parsers'
          if vim.tbl_contains(installed_parsers, language) then
            attach_parser(event.buf, language)
          elseif vim.tbl_contains(parsers, language) then
            treesitter.install(language):await(function()
              if vim.api.nvim_buf_is_valid(event.buf) then
                attach_parser(event.buf, language)
              end
            end)
          else
            attach_parser(event.buf, language)
          end
        end,
        desc = 'Install and attach Treesitter parsers',
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      }

      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'
      local swap = require 'nvim-treesitter-textobjects.swap'

      local selections = {
        aa = '@parameter.outer',
        ia = '@parameter.inner',
        af = '@function.outer',
        ['if'] = '@function.inner',
        ac = '@class.outer',
        ic = '@class.inner',
      }

      local function map_selection(key, query)
        vim.keymap.set({ 'x', 'o' }, key, function()
          select.select_textobject(query, 'textobjects')
        end, { desc = 'Select ' .. query })
      end

      for key, query in pairs(selections) do
        map_selection(key, query)
      end

      vim.keymap.set('n', '<C-Space>', 'van', { remap = true, desc = 'Start Treesitter selection' })
      vim.keymap.set('x', '<C-Space>', 'an', { remap = true, desc = 'Expand Treesitter selection' })
      vim.keymap.set('x', '<M-Space>', 'in', { remap = true, desc = 'Shrink Treesitter selection' })
      vim.keymap.set('x', '<C-s>', function()
        select.select_textobject('@local.scope', 'locals')
      end, { desc = 'Expand selection to local scope' })

      local movements = {
        [']m'] = { move.goto_next_start, '@function.outer' },
        [']]'] = { move.goto_next_start, '@class.outer' },
        [']M'] = { move.goto_next_end, '@function.outer' },
        [']['] = { move.goto_next_end, '@class.outer' },
        ['[m'] = { move.goto_previous_start, '@function.outer' },
        ['[['] = { move.goto_previous_start, '@class.outer' },
        ['[M'] = { move.goto_previous_end, '@function.outer' },
        ['[]'] = { move.goto_previous_end, '@class.outer' },
      }

      local function map_movement(key, callback, query)
        vim.keymap.set({ 'n', 'x', 'o' }, key, function()
          callback(query, 'textobjects')
        end, { desc = 'Move to ' .. query })
      end

      for key, movement in pairs(movements) do
        map_movement(key, movement[1], movement[2])
      end

      vim.keymap.set('n', '<leader>a', function()
        swap.swap_next '@parameter.inner'
      end, { desc = 'Swap with next parameter' })
      vim.keymap.set('n', '<leader>A', function()
        swap.swap_previous '@parameter.inner'
      end, { desc = 'Swap with previous parameter' })
    end,
  },
}
