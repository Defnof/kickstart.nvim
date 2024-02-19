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
    "tpope/vim-fugitive",
    keys = {
      {
        "<leader>hg",
        function()
          vim.api.nvim_feedkeys(":G ", "n", true)
        end,
        desc = "Activate Fu[g]itive"
      },
    }
  },
  { "tpope/vim-rhubarb", },
  { 'tpope/vim-dadbod', },
  { "tpope/vim-eunuch", }
}
