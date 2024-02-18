-- NOTE: Various LSP and IDE related plugins and their config

return {
  -- NOTE: This is where your plugins related to LSP can be installed.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    config = function()
      require 'overrides.lsp'
    end,
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    config = function()
      require 'overrides.cmp'
    end,
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    keys = {
      {
        "<leader>/",
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        mode = "n"
      },
      {
        "<leader>/",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
        mode = "v"
      }
    },
    opts = {
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = false,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = false,
      },
    }
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- Use a sub-list to run only the first available formatter
        javascript = { "biome", },
        typescript = { "biome", },
        -- Use the "*" filetype to run formatters on all filetypes.
        ["*"] = { "codespell" },
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      open_mapping = [[<A-i>]],
      direction = 'float',
    },
  },

  -- treesitter setup
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'overrides.treesitter'
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- NOTE: TS
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    ft = { "typescript", "typescriptreact" },
    keys = {
      {
        "<leader>ct", "<CMD>TSC<CR>", desc = "[C]ode [T]ype checking",
      }
    },
    opts = {
      flags = {
        build = true,
      },
    },
  },

  {
    "pmizio/typescript-tools.nvim",
    enabled = true,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      on_attach = function(client, bufnr)
        require "utils.mapping".map_lsp_keybinds(bufnr)
        -- require "workspace-diagnostics".populate_workspace_diagnostics(client, bufnr)
      end
    },
  }

}
