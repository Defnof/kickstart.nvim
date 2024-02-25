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

-- NOTE: Telescope fix, make it so return from telescope does not enable insert mode
autocmd('WinLeave', {
  callback = function()
    if vim.bo.ft == 'TelescopePrompt' and vim.fn.mode() == 'i' then
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
        'i',
        false
      )
    end
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
