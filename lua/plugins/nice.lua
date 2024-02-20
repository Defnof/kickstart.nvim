return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    "TobinPalmer/Tip.nvim",
    event = "VimEnter",
    init = function()
      -- Default config
      --- @type Tip.config
      require("tip").setup({
        seconds = 2,
        title = "Tip!",
        url = "https://vtip.43z.one", -- Or https://vimiscool.tech/neotip
      })
    end,
  },

  {
    "m4xshen/hardtime.nvim",
    enabled = false,
    event = "BufEnter",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {}
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {},
    config = function()
      -- document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>g'] = { name = '[G]oto', _ = 'which_key_ignore' },
        ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
        ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        ['<leader>p'] = { name = '[P]roject', _ = 'which_key_ignore' },
        ['<leader>n'] = { name = '[N] Manage', _ = 'which_key_ignore' },
        ['<leader>m'] = { name = '[M]ove', _ = 'which_key_ignore' },
        ['<leader>S'] = { name = '[S]urround', _ = 'which_key_ignore' },
        ['<leader><space>'] = { name = '[ ] Run', _ = 'which_key_ignore' },
      }
      -- register which-key VISUAL mode
      -- required for visual <leader>hs (hunk stage) to work
      require('which-key').register({
        ['<leader>'] = { name = 'VISUAL <leader>' },
        ['<leader>h'] = { 'Git [H]unk' },
      }, { mode = 'v' })
    end,
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    config = function()
      require 'overrides.telescope'
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      {
        "piersolenski/telescope-import.nvim",
      }
    },
  },

  {
    "0x00-ketsu/autosave.nvim",
    enabled = false,
    event = { "InsertLeave", "TextChanged" },
    keys = { {
      "<leader>an",
      "<cmd>ASToggle<CR>",
      desc = "Toggle Auto Save",
    } },
    opts = {
      enable = true,
      prompt_style = "stdout",
      prompt_message = function()
        return "Autosave: saved at " .. vim.fn.strftime "%H:%M:%S"
      end,
      events = { "InsertLeave", "TextChanged" },
      conditions = {
        exists = true,
        modifiable = true,
        filename_is_not = {},
        filetype_is_not = {},
      },
      write_all_buffers = false,
      debounce_delay = 650,
    },
  },
  {
    "epwalsh/obsidian.nvim",
    enabled = false,
    event = "VeryLazy",
    version = "*",
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "all",
          path = "~/Documents/Brain",
        },
      },
    },
  },
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<leader>nn", "<cmd>Neorg workspace<CR>", desc = "Start [N]eorg" } },
    opts = {
      load = {
        ["core.defaults"] = {},  -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.completion"] = {  -- Add completion for norg notes
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/Documents/Brain",
            },
            default_workspace = "notes",
          },
        },
      },
    },
  },

  {
    "mbbill/undotree",
    opts = {},
    keys = {
      { "<leader>u", "<CMD>UndotreeToggle<CR>", desc = "Toggle [U]ndoTree" }
    }
  },
}
