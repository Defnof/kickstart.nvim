return {
  {
    'nvim-tree/nvim-tree.lua',
    -- NOTE: Needed to make sure nvim-tree loads, for some reason it doesn't
    -- NOTE: Key for toggling NvimTree, makes it consistent with toggleterm
    event = 'VeryLazy',
    keys = {
      {
        '<A-e>',
        '<cmd>NvimTreeToggle<CR>',
        desc = 'Toggle NvimTree',
      },
    },
    opts = {},
  },
}
