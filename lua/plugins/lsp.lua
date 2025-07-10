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
      { 'WhoIsSethDaniel/mason-tool-installer.nvim', config = true },

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
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
      },
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
        '<leader>/',
        function()
          require('Comment.api').toggle.linewise.current()
        end,
        mode = 'n',
      },
      {
        '<leader>/',
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
        mode = 'v',
      },
    },
    opts = {
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = false,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = false,
      },
    },
  },

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        desc = '[C]ode [F]ormat',
      },
      {
        '<leader>cT',
        function()
          vim.g.autoformat = not vim.g.autoformat
        end,
        desc = '[C]ode [T]oggle Formatting',
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        -- Use a sub-list to run only the first available formatter
        javascript = { 'biome' },
        typescript = { 'biome' },
        typescriptreact = { 'biome' },
        javascriptreact = { 'biome' },
        shell = { 'shfmt' },
        sh = { 'shfmt' },
        -- Use the "*" filetype to run formatters on all filetypes.
        -- ['*'] = { 'codespell' },
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ['_'] = { 'trim_whitespace' },
      },
      format_on_save = function()
        if not vim.g.autoformat then
          return
        end

        return {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
    },
    config = function(_, opts)
      -- NOTE: Enable formatting by default
      vim.g.autoformat = true
      require('conform').setup(opts)
    end,
  },

  {
    'akinsho/toggleterm.nvim',
    version = '*',
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
    'dmmulroy/tsc.nvim',
    cmd = 'TSC',
    ft = { 'typescript', 'typescriptreact' },
    keys = {
      {
        '<leader>ct',
        '<CMD>TSC<CR>',
        desc = '[C]ode [T]ype checking',
      },
    },
    opts = {
      flags = {
        build = true,
      },
    },
  },

  {
    'pmizio/typescript-tools.nvim',
    ft = {
      'typescript',
      'typescriptreact',
      'javascript',
      'javascriptreact',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {
      on_attach = function(client, bufnr)
        require('utils.mapping').map_lsp_keybinds(bufnr)
      end,
    },
  },

  {
    'mrcjkb/rustaceanvim',
    version = '^3',
    ft = { 'rust' },
    config = function(_, _)
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            require('utils.mapping').map_lsp_keybinds(bufnr)
          end,
        },
      }
    end,
  },

  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    event = 'LspAttach',
    keys = {
      {
        '<Leader>cl',
        function()
          local lines = require 'lsp_lines'
          lines.toggle()

          local virtual_lines_config = vim.diagnostic.config().virtual_lines -- Disable virtual_text since it's redundant due to lsp_lines.
          vim.diagnostic.config {
            virtual_text = not virtual_lines_config,
          }
        end,
        desc = 'Toggle [C]ode LSP [l]ines',
      },
    },
    config = function()
      require('lsp_lines').setup()

      local virtual_lines_config = vim.diagnostic.config()
      vim.diagnostic.config {
        virtual_text = not virtual_lines_config,
      }
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    config = true,
    event = 'VeryLazy',
    keys = {
      {
        '<leader>cc',
        '<cmd>TSContextToggle<CR>',
        desc = 'Toggle [C]ontext',
      },
    },
  },

  {
    'windwp/nvim-autopairs',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
}
