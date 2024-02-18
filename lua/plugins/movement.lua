return {
  {
    -- NOTE: Work with registers
    "tversteeg/registers.nvim",
    name = "registers",
    keys = {
      { '"',     mode = { "n", "v" } },
      { "<C-R>", mode = "i" },
    },
  },
  {
    -- NOTE: Surround commands
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest featuresnvim
    event = "InsertEnter",
    dependencies = {
      {
        -- NOTE: Add UI for surround commands
        "roobert/surround-ui.nvim",
        dependencies = {
          "kylechui/nvim-surround",
          "folke/which-key.nvim",
        },
        opts = {
          root_key = "S",
        },
      },
    },
    opts = {},
  },
  {
    -- NOTE: Allow jj and jk to escape insert mode
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = true,
  },
  {
    -- NOTE: Improved search and jumps
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {}, ---@type Flash.Config
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>ma",
        function()
          require('harpoon'):list():append()
        end,
        desc = "[A]ppend to Harpoon",
      },
      {
        "<C-e>",
        function()
          require('harpoon').ui:toggle_quick_menu(require "harpoon":list())
        end,
        desc = "[L]ist in Harpoon",
      },
      {
        "<C-p>",
        function()
          require('harpoon'):list():prev()
        end,
        desc = "[M]ove Harpoon Prev",
      },
      {
        "<C-n>",
        function()
          require('harpoon'):list():next()
        end,
        desc = "[M]ove Harpoon Next",
      }
    }
  }
}
