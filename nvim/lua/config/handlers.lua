vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    require('core.default').setup()
  end
});

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "lua",
    "dart",
    "yaml",
    "html", "xhtml",
  },
  callback = function()
    require('core.tiny-language').setup()
  end
});

vim.api.open_terminal = function ()
  vim.cmd('split')
  vim.cmd('res -10')

  local bufs = vim.api.nvim_list_bufs()

  for _, id in ipairs(bufs) do
    local type = vim.api.nvim_buf_get_option(id, 'buftype')

    if (type == 'terminal') then
      vim.cmd('buffer ' .. id)
      vim.cmd('startinsert')
      return
    end
  end

  vim.cmd('terminal')
  vim.cmd('file terminal')
  vim.cmd('startinsert')
end
