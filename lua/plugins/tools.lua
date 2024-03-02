return {
  {
    'crnvl96/lazydocker.nvim',
    event = 'VeryLazy',
    opts = {}, -- automatically calls `require("lazydocker").setup()`
    keys = {
      {
        '<A-d>',
        '<cmd>LazyDocker<CR>',
        desc = 'LazyDocker',
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
  },
  {
    'stevearc/oil.nvim',
    enabled = false,
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      {
        '-',
        '<cmd>Oil<CR>',
        desc = '[-] Open parent directory',
      },
    },
  },
  {
    'nvim-tree/nvim-tree.lua',
    event = 'VimEnter',
    keys = { { '<A-e>', '<CMD>NvimTreeToggle<CR>', desc = 'Toggle Tree-view' } },
    opts = {
      sort = {
        sorter = 'case_sensitive',
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
      update_focused_file = {
        enable = true,
        update_root = true,
      },
    },
  },
  {
    'tpope/vim-fugitive',
    keys = {
      {
        '<leader>ghf',
        function()
          vim.api.nvim_feedkeys(':G ', 'n', true)
        end,
        desc = 'Activate [G]it [F]ugitive',
      },
    },
  },
  { 'tpope/vim-rhubarb' },
  { 'tpope/vim-dadbod' },
  { 'tpope/vim-eunuch' },
}
