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
    opts = {
      disable_netrw = true,
      update_focused_file = { enable = true, update_root = true, },
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        root_folder_label = false,
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
    },
  },
}
