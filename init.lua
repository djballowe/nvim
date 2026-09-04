if vim.fn.has 'nvim-0.12' == 0 then
  error 'This configuration requires Neovim 0.12 or newer.'
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- nvim-tree recommends disabling netrw before any plugins are loaded.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'
