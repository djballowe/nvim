local function find_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local cwd = vim.fn.getcwd()
  local current_dir = current_file == '' and cwd or vim.fs.dirname(current_file)

  local result = vim.system({ 'git', '-C', current_dir, 'rev-parse', '--show-toplevel' }, { text = true }):wait()
  local git_root = result.code == 0 and vim.trim(result.stdout or '') or ''

  if git_root == '' then
    vim.notify('Not a Git repository. Searching from the current working directory.', vim.log.levels.INFO)
    return cwd
  end

  return git_root
end

local function live_grep_git_root()
  require('telescope.builtin').live_grep {
    search_dirs = { find_git_root() },
  }
end

return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      local telescope = require 'telescope'
      local builtin = require 'telescope.builtin'

      telescope.setup {
        defaults = {
          file_ignore_patterns = { 'node_modules/.*' },
        },
        extensions = {
          undo = {
            side_by_side = true,
            layout_strategy = 'vertical',
            layout_config = {
              preview_height = 0.8,
            },
          },
        },
      }

      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'undo')

      vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {
        desc = 'Search from the current buffer Git root',
      })

      vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search Git files' })
      vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Search files' })
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search help' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search current word' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search by grep' })
      vim.keymap.set('n', '<leader>sG', '<cmd>LiveGrepGitRoot<cr>', { desc = 'Search by grep from Git root' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search diagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Resume search' })
    end,
  },
}
