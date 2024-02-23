return {
  {
    "crnvl96/lazydocker.nvim",
    event = "VeryLazy",
    opts = {}, -- automatically calls `require("lazydocker").setup()`
    keys = {
      {
        "<A-d>",
        "<cmd>LazyDocker<CR>",
        desc = "LazyDocker",
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
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
        "<leader>ghf",
        function()
          vim.api.nvim_feedkeys(":G ", "n", true)
        end,
        desc = "Activate [G]it [F]ugitive"
      },
    }
  },
  { "tpope/vim-rhubarb", },
  { 'tpope/vim-dadbod', },
  { "tpope/vim-eunuch", }
}
