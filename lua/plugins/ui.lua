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
      flavour = 'macchiato',
      transparent_background = true,
      term_colors = true,
      custom_highlights = function(colors)
        return {
          LuaLineDiffAdd = {
            bg = colors.surface0,
            fg = colors.green,
            bold = true,
          },
          LuaLineDiffChange = {
            bg = colors.surface0,
            fg = colors.peach,
            bold = true,
          },
          LuaLineDiffDelete = {
            bg = colors.surface0,
            fg = colors.red,
            bold = true,
          },
          LuaLineDiagnosticsError = {
            bg = colors.surface0,
            fg = colors.red,
            bold = true,
          },
          LuaLineDiagnosticsWarn = {
            bg = colors.surface0,
            fg = colors.yellow,
            bold = true,
          },
          LuaLineDiagnosticsInfo = {
            bg = colors.surface0,
            fg = colors.blue,
            bold = true,
          },
          LuaLineDiagnosticsHint = {
            bg = colors.surface0,
            fg = colors.green,
            bold = true,
          },
          SymbolUsageRef = {
            fg = colors.surface0,
            bg = colors.peach,
            bold = true,
          },
          SymbolUsageRefRound = {
            fg = colors.peach,
            bold = true,
          },
          SymbolUsageDef = {
            fg = colors.surface0,
            bg = colors.pink,
            bold = true,
          },
          SymbolUsageDefRound = {
            fg = colors.pink,
            bold = true,
          },
          SymbolUsageImpl = {
            fg = colors.surface0,
            bg = colors.teal,
            bold = true,
          },
          SymbolUsageImplRound = {
            fg = colors.teal,
            bold = true,
          },
          Rainbow1 = { fg = colors.red },
          Rainbow2 = { fg = colors.yellow },
          Rainbow3 = { fg = colors.blue },
          Rainbow4 = { fg = colors.green },
          Rainbow5 = { fg = colors.pink },
          Rainbow6 = { fg = colors.teal },
        }
      end,
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
          indentscope_color = '',
        },
        indent_blankline = {
          enabled = true,
          scope_color = 'lavender', -- catppuccin color (eg. `lavender`) Default: text
          colored_indent_levels = false,
        },
        noice = true,
        ufo = true,
        lsp_trouble = true,
        which_key = true,
        headlines = true,
        mason = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
          },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
          },
          inlay_hints = {
            background = true,
          },
        },
        treesitter_context = true,
        symbols_outline = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>nm',
        '<cmd>Noice<CR>',
        desc = '[n] Show [m]essages',
      },
      {
        '<leader>nD',
        '<cmd>Noice dismiss<CR>',
        desc = '[n] [D]ismiss messages',
      },
    },
    opts = {
      views = {
        notify = {
          replace = true,
        },
      },
      lsp = {
        progress = {
          -- enabled = true,
          enabled = true,
          -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
          -- See the section on formatting for more details on how to customize.
          --- @type NoiceFormat|string
          format = 'lsp_progress',
          --- @type NoiceFormat|string
          format_done = 'lsp_progress_done',
          throttle = 1000 / 30, -- frequency to update lsp progress message
          view = 'notify',
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      {
        'rcarriga/nvim-notify',
        opts = {
          top_down = false,
          background_colour = '#000000',
        },
      },
    },
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    dependencies = {
      { 'dokwork/lualine-ex' },
    },
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
            },
          },
        },
        lualine_b = {
          -- Override 'encoding': Don't display if encoding is UTF-8.
          function()
            local ret, _ = (vim.bo.fenc or vim.go.enc):gsub('^utf%-8$', '')
            return ret
          end,

          -- fileformat: Don't display if &ff is unix.
          function()
            local ret, _ = vim.bo.fileformat:gsub('^unix$', '')
            return ret
          end,
          'location',
          {
            'branch',
            cond = function()
              return vim.fn.winwidth(0) > 120
            end,
          },
        },
        lualine_c = {
          {
            'diff',
            separator = { right = '' },
            colored = true, -- Displays a colored diff status if set to true
            diff_color = {
              -- Same color values as the general color option can be used here.
              added = 'LuaLineDiffAdd', -- Changes the diff's added color
              modified = 'LuaLineDiffChange', -- Changes the diff's modified color
              removed = 'LuaLineDiffDelete', -- Changes the diff's removed color you
            },
            symbols = { added = '+', modified = ' ~', removed = ' -' }, -- Changes the symbols used by the diff.
            source = nil, -- A function that works as a data source for diff.
            -- It must return a table as such:
            --   { added = add_count, modified = modified_count, removed = removed_count }
            -- or nil on failure. count <= 0 won't be displayed.
          },
        },
        lualine_x = {
          {
            'diagnostics',
            separator = { right = '', left = '' },
            diagnostics_color = {
              -- Same values as the general color option can be used here.
              error = 'LuaLineDiagnosticsError', -- Changes diagnostics' error color.
              warn = 'LuaLineDiagnosticsWarn', -- Changes diagnostics' warn color.
              info = 'LuaLineDiagnosticsInfo', -- Changes diagnostics' info color.
              hint = 'LuaLineDiagnosticsHint', -- Changes diagnostics' hint color.
            },
            update_in_insert = true, -- Update diagnostics in insert mode.
          },
        },
        lualine_y = {
          { require('recorder').recordingStatus },
          { require('recorder').displaySlots },
          {
            -- NOTE: Formatter toggle
            function()
              local ok = pcall(require, 'conform')

              if not ok then
                return ''
              end

              if not vim.g.autoformat then
                return ''
              end

              return '󰉢' .. ' conform '
            end,
          },
        },
        lualine_z = {
          {
            'ex.lsp.all',
            icons_only = true,
            icons = {
              ['lua_ls'] = { '󰢱', fg = 'black' },
              ['rust_analyzer'] = { '', fg = 'black' },
              ['jsonls'] = { '', fg = 'black' },
              ['biome'] = { '', fg = 'black' },
              ['typescript-tools'] = { '', fg = 'black' },
              ['tsserver'] = { '', fg = 'black' },
              ['tailwindcss'] = { '󱏿', fg = 'black' },
            },
            only_attached = true,

            -- If true then every closed client will be echoed:
            notify_enabled = true,

            -- The name of highlight group which should be used in echo:
            notify_hl = 'Comment',
          },
        },
        -- lualine_z = { { 'filetype', colored = false, }
        -- }
      },
      inactive_sections = {
        lualine_a = {
          {
            'filename',
            path = 4,
            symbols = {
              modified = '', -- Text to show when the file is modified.
              readonly = '', -- Text to show when the file is non-modifiable or readonly.
              unnamed = '󰃮', -- Text to show for unnamed buffers.
              newfile = '', -- Text to show for newly created file before first write
            },
          },
        },
        lualine_b = { 'location' },
        lualine_c = {},
        lualine_x = {},
      },
      extensions = {
        'fzf',
        'lazy',
        'nvim-tree',
        'symbols-outline',
        'toggleterm',
        'trouble',
      },
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        component_separators = '',
        -- component_separators = { left = '', right = ''},
        section_separators = { left = '', right = '' },
      },
    },
  },

  {
    'rasulomaroff/reactive.nvim',
    event = 'VeryLazy',
    config = function()
      require('reactive').setup {
        load = {
          'catppuccin-macchiato-cursor',
          'catppuccin-macchiato-cursorline',
        },
      }
    end,
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'VeryLazy',
    opts = {
      highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      },
    },
    config = function(_, opts)
      require('rainbow-delimiters.setup').setup(opts)
    end,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    enabled = true,
    main = 'ibl',
    config = function()
      local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      }
      local hooks = require 'ibl.hooks'
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require('ibl').setup {
        debounce = 100,
        indent = { char = '┊' },
        whitespace = { highlight = { 'Whitespace', 'NonText' } },
        scope = { exclude = { language = { 'lua' } } },
      }

      hooks.register(
        hooks.type.SCOPE_HIGHLIGHT,
        hooks.builtin.scope_highlight_from_extmark
      )
    end,
    opts = {},
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        mode = 'buffers', -- set to "tabs" to only show tabpages instead
        separator_style = { '', '' },
        indicator = {
          icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = 'none',
        },
        always_show_bufferline = false,
        max_name_length = 13,
        max_prefix_length = 11, -- prefix used when a buffer is de-duplicated
        truncate_names = true, -- whether or not tab names should be truncated
        tab_size = 13,
        close_icon = '',
        buffer_close_icon = '',
        hover = { enabled = false },
        close_command = nil, -- can be a string | function, | false see "Mouse actions"
        right_mouse_command = nil, -- can be a string | function | false, see "Mouse actions"
        left_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            text_align = 'left',
            separator = true,
          },
        },
      },
    },
  },

  -- init.lua
  {
    'lukas-reineke/headlines.nvim',
    enabled = false,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {},
  },
}
