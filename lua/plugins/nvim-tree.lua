return {
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      sort = {
        sorter = 'case_sensitive',
      },
      view = {
        width = 50,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
    },
    keys = {
      { '<leader>pv', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle file tree' },
      { '<leader>f', '<cmd>NvimTreeFindFile<cr>', desc = 'Find current file in tree' },
      { '<leader>ct', '<cmd>NvimTreeCollapse<cr>', desc = 'Collapse file tree' },
    },
  },
}
