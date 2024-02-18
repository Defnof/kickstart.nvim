return {
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        alpha = true,
        flash = true,
        barbecue = {
          dim_dirname = true, -- directory name is dimmed by default
          bold_basename = true,
          dim_context = false,
          alt_background = false,
        },
        mini = {
          enabled = false,
          indentscope_color = "",
        },
        indent_blankline = {
          enabled = true,
          scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
          colored_indent_levels = false,
        },
        noice = true,
        ufo = true,
        lsp_trouble = true,
        which_key = true
      }
    },
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
        transparent_background = true
      })
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      views = {
        notify = {
          replace = true,
        },
      },
      lsp = {
        progress = {
          enabled = true,
          -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
          -- See the section on formatting for more details on how to customize.
          --- @type NoiceFormat|string
          format = "lsp_progress",
          --- @type NoiceFormat|string
          format_done = "lsp_progress_done",
          throttle = 1000 / 30, -- frequency to update lsp progress message
          view = "notify",
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      {
        "rcarriga/nvim-notify",
        opts = {
          top_down = false,
          background_colour = "#000000"
        }
      },
    }
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      sections = {
        lualine_a = {
          {
            'filename',
            path = 4,
            symbols = {
              modified = '', -- Text to show when the file is modified.
              readonly = '', -- Text to show when the file is non-modifiable or readonly.
              unnamed = '󰃮', -- Text to show for unnamed buffers.
              newfile = '', -- Text to show for newly created file before first write
            }
          }
        },
        lualine_b = {
          -- Override 'encoding': Don't display if encoding is UTF-8.
          function()
            local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
            return ret
          end,

          -- fileformat: Don't display if &ff is unix.
          function()
            local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
            return ret
          end,
          'location'
        },
        lualine_c = { { 'branch', cond = function() return vim.fn.winwidth(0) > 120 end }, 'diff' },
        lualine_x = {},
        lualine_y = { 'diagnostics', },
        lualine_z = { { 'filetype', colored = false, }
        }
      },
      extensions = { 'fzf', 'lazy', 'nvim-tree', 'symbols-outline', 'toggleterm', 'trouble', },
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        component_separators = '',
        section_separators = { left = '', right = '' },
      },
    },
  },

  {
    "rasulomaroff/reactive.nvim",
    -- WARN: reactive broke via vimdoc update keep at v1 for now
    tag = "v1.0.0",
    event = "VeryLazy",
    config = function()
      require('reactive').setup {
        load = { 'catppuccin-macchiato-cursor', 'catppuccin-macchiato-cursorline' }
      }
    end,
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("rainbow-delimiters.setup").setup(opts)
    end,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    enabled = true,
    main = 'ibl',
    opts = {},
  },
}
