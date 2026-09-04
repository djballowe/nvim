vim.o.autoread = true

local reload_group = vim.api.nvim_create_augroup('ExternalFileChanges', { clear = true })
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = reload_group,
  pattern = '*',
  callback = function()
    vim.notify('File changed on disk. Buffer updated', vim.log.levels.INFO)
  end,
  desc = 'Notify when a buffer is reloaded after an external change',
})

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_group,
  pattern = '*',
  callback = function()
    vim.hl.on_yank()
  end,
  desc = 'Highlight text after yanking',
})
