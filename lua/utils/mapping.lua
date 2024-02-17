local M = {}

M.map = vim.keymap.set
M.nmap = function(key, action, desc, opts)
  local options = opts ~= nil and opts or {}
  options['desc'] = desc
  return vim.keymap.set('n', key, action, options)
end

return M;
