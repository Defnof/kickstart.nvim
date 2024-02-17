-- [[ Basic Keymaps ]]
local M = require('utils.mapping')
local map = M.map
local nmap = M.nmap

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
nmap('k', "v:count == 0 ? 'gk' : 'k'", "", { expr = true, silent = true })
nmap('j', "v:count == 0 ? 'gj' : 'j'", "", { expr = true, silent = true })

-- Quit and Save
nmap('<leader>s', '<CMD>w<CR>', "[S]ave Buffer")
nmap('<A-q>', '<CMD>qa!<CR>', "[Q]uit Kickstart")

-- toggle relative numbers
nmap('<leader>rn', function()
  vim.o.signcolumn = vim.o.signcolumn == "yes" and "no" or "yes"
  vim.o.relativenumber = not vim.o.relativenumber
end, 'Toggle [R]elative [N]umbers')

-- Map : to ; for faster CMD-ing
nmap(';', ':', '', {nowait = true})
