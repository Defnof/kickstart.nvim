local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local get_window_config = vim.api.nvim_win_get_config

autocmd('WinEnter', {
  callback = function()
    local floating = get_window_config(0).relative ~= ''
    vim.diagnostic.config {
      virtual_text = floating,
      virtual_lines = not floating,
    }
  end,
})

local parse_highlight = function()
  local highlights = require 'config.highlights'

  for key, value in pairs(highlights) do
    vim.api.nvim_set_hl(0, key, value)
  end
end

autocmd('ColorScheme', {
  callback = function()
    parse_highlight()
  end,
})

-- autocmd('InsertEnter', {
--   callback = function()
--     vim.o.relativenumber = false
--   end,
-- })
--
-- autocmd('InsertLeave', {
--   callback = function()
--     vim.o.relativenumber = true
--   end,
-- })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = augroup('YankHighlight', { clear = true }),
  pattern = '*',
})
