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

  -- NOTE: Backend for ranger, run ranger in nvim
  {
    'kevinhwang91/rnvimr',
    keys = {
      {
        '<A-f>',
        '<cmd>RnvimrToggle<CR>',
        desc = 'Toggle Ranger',
      },
    },
  },

  {
    'stevearc/oil.nvim',
    opts = {},
    keys = { {
      '-',
      '<cmd>Oil<CR>',
      desc = 'Open parent directory',
    } },
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
