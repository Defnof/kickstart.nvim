return {
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "-", "<cmd>Oil<CR>", desc = "[-] Open parent directory",
      }
    }
  },
  {
    "tpope/vim-fugitive"
  },
  { "tpope/vim-rhubarb", },
  { 'tpope/vim-dadbod', },
  { "tpope/vim-eunuch", }
}
