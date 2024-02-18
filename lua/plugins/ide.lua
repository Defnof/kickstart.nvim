return {
  {
    "malbertzard/inline-fold.nvim",
    ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
    opts = {
      defaultPlaceholder = "…",
      queries = {
        -- Some examples you can use
        html = {
          { pattern = 'class="([^"]*)"', placeholder = "@" }, -- classes in html
          { pattern = 'href="(.-)"' },                        -- hrefs in html
          { pattern = 'src="(.-)"' },                         -- HTML img src attribute
        },
      },
    },
  },
  {
    "razak17/tailwind-fold.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
    opts = {},
  },
  {
    "vuki656/package-info.nvim",
    ft = "json",
    opts = {
      colors = {
        up_to_date = "#98C379", -- Text color for up to date dependency virtual text
        outdated = "#D19A66",   -- Text color for outdated dependency virtual text
      },
      icons = {
        enable = true, -- Whether to display icons
        style = {
          up_to_date = "|  ", -- Icon for up to date dependencies
          outdated = "|  ", -- Icon for outdated dependencies
        },
      },
      autostart = true,               -- Whether to autostart when `package.json` is opened
      hide_up_to_date = true,         -- It hides up to date versions when displaying virtual text
      hide_unstable_versions = false, -- It hides unstable versions from version list e.g next-11.1.3-canary3
      -- Can be `npm`, `yarn`, or `pnpm`. Used for `delete`, `install` etc...
      -- The plugin will try to auto-detect the package manager based on
      -- `yarn.lock` or `package-lock.json`. If none are found it will use the
      -- provided one, if nothing is provided it will use `yarn`
      package_manager = "pnpm",
    },
    keys = {
      {
        "<leader>nf",
        function()
          require("package-info").show {
            force = true,
          }
        end,
        desc = "[F]etch package versions",
      },
      {
        "<leader>nt",
        function()
          require("package-info").toggle()
        end,
        desc = "[T]oggle check packages",
      },
      {
        "<leader>nu",
        function()
          require("package-info").update()
        end,
        desc = "[U]pdate package",
      },
      {
        "<leader>nd",
        function()
          require("package-info").delete()
        end,
        desc = "[D]elete package",
      },
      {
        "<leader>nc",
        function()
          require("package-info").change_version()
        end,
        desc = "[C]hange package version",
      },
      {
        "<leader>nt",
        function()
          require("package-info").install()
        end,
        desc = "Ins[t]all package",
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "artemave/workspace-diagnostics.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("workspace-diagnostics").setup(opts)
    end
  },
  {
    "chrisgrieser/nvim-rulebook",
    keys = {
      {
        "<leader>ri",
        function()
          require("rulebook").ignoreRule()
        end,
        desc = "[I]gnore Rule",
      },
      {
        "<leader>rl",
        function()
          require("rulebook").lookupRule()
        end,
        desc = "[L]ookup Rule",
      },
      {
        "<leader>ry",
        function()
          require("rulebook").yankDiagnosticCode()
        end,
        desc = "[Y]ank Diagnostic Code",
      },
    },
  },
  {
    "0x100101/lab.nvim",
    ft = { "typescript", "javascript" },
    build = "cd js && npm ci",
    opts = {
      code_runner = {
        enabled = true,
      },
    },
    keys = {
      {
        "<leader><space>c", "<cmd>Lab code run<CR>", desc = "Run Lab [C]ode",
      }
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "jedrzejboczar/toggletasks.nvim",
    event = "VeryLazy",
    enabled = true,
    cond = function()
      return vim.fn.findfile("./.nvim/toggletasks", ".")
    end,
    keys = {
      { "<leader><space>r", "<cmd>Telescope toggletasks spawn<CR>",  desc = "[R]un tasks" },
      { "<leader><space>s", "<cmd>Telescope toggletasks select<CR>", desc = "[S]elect tasks" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "akinsho/toggleterm.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      debug = false,
      silent = false,     -- don't show "info" messages
      short_paths = true, -- display relative paths when possible
      -- Paths (without extension) to task configuration files (relative to scanned directory)
      -- All supported extensions will be tested, e.g. '.toggletasks.json', '.toggletasks.yaml'
      search_paths = {
        ".nvim/toggletasks",
      },
      -- Directories to consider when searching for available tasks for current window
      scan = {
        global_cwd = true,    -- vim.fn.getcwd(-1, -1)
        tab_cwd = true,       -- vim.fn.getcwd(-1, tab)
        win_cwd = true,       -- vim.fn.getcwd(win)
        lsp_root = true,      -- root_dir for first LSP available for the buffer
        dirs = {},            -- explicit list of directories to search or function(win): dirs
        rtp = false,          -- scan directories in &runtimepath
        rtp_ftplugin = false, -- scan in &rtp by filetype, e.g. ftplugin/c/toggletasks.json
      },
      tasks = {},             -- list of global tasks or function(win): tasks
      -- this is basically the "Config format" defined using Lua tables
      -- Language server priorities when selecting lsp_root (default is 0)
      lsp_priorities = {
        ["null-ls"] = -10,
      },
      -- Defaults used when opening task's terminal (see Terminal:new() in toggleterm/terminal.lua)
      toggleterm = {
        close_on_exit = true,
        hidden = true,
      },
      -- Configuration of telescope pickers
      telescope = {
        spawn = {
          open_single = true,   -- auto-open terminal window when spawning a single task
          show_running = false, -- include already running tasks in picker candidates
          -- Replaces default select_* actions to spawn task (and change toggleterm
          -- direction for select horiz/vert/tab)
          mappings = {
            select_float = nil,
            spawn_smart = "<C-s>", -- all if no entries selected, else use multi-select
            spawn_all = nil,       -- all visible entries
            spawn_selected = nil,  -- entries selected via multi-select (default <tab>)
          },
        },
        -- Replaces default select_* actions to open task terminal (and change toggleterm
        -- direction for select horiz/vert/tab)
        select = {
          mappings = {
            select_float = nil,
            open_smart = "<C-o>",
            open_all = nil,
            open_selected = nil,
            kill_smart = "<C-k>",
            kill_all = nil,
            kill_selected = nil,
            respawn_smart = "<C-r>",
            respawn_all = nil,
            respawn_selected = nil,
          },
        },
      },
    },
  },
  {
    "axelvc/template-string.nvim",
    event = "VeryLazy",
    opts = {
      filetypes = {
        "html",
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact",
      },                              -- filetypes where the plugin is active
      jsx_brackets = true,            -- must add brackets to JSX attributes
      remove_template_string = false, -- remove backticks when there are no template strings
      restore_quotes = {
        -- quotes used when "remove_template_string" option is enabled
        normal = [[']],
        jsx = [["]],
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = "kevinhwang91/promise-async",
    opts = {
      open_fold_hl_timeout = 150,
      close_fold_kinds = { "imports", "comment" },
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
      provider_selector = function(bufnr, filetype, buftype)
        local ftMap = {
          vim = "indent",
          python = { "indent" },
          git = "",
        }
        -- if you prefer treesitter provider rather than lsp,
        -- return ftMap[filetype] or {'treesitter', 'indent'}
        return ftMap[filetype]

        -- refer to ./doc/example.lua for detail
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    },
    config = function(_, opts)
      vim.o.foldcolumn = "0" -- '0' is not bad
      vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require("ufo").setup(opts)
    end,
  },
  {
    "Wansmer/symbol-usage.nvim",
    enabled = true,
    event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    opts = {
      ---@type table<string, any> `nvim_set_hl`-like options for highlight virtual text
      hl = { link = "Comment" },
      ---Additional filter for kinds. Recommended use in the filetypes override table.
      ---fiterKind: function(data: { symbol:table, parent:table, bufnr:integer }): boolean
      ---`symbol` and `parent` is an item from `textDocument/documentSymbol` request
      ---See: #filter-kinds
      ---@type table<lsp.SymbolKind, filterKind[]>
      kinds_filter = {},
      ---@type 'above'|'end_of_line'|'textwidth' above by default
      vt_position = "above",
      ---Text to display when request is pending. If `false`, extmark will not be
      ---created until the request is finished. Recommended to use with `above`
      ---vt_position to avoid "jumping lines".
      ---@type string|table|false
      request_pending_text = "loading...",
      ---The function can return a string to which the highlighting group from `opts.hl` is applied.
      ---Alternatively, it can return a table of tuples of the form `{ { text, hl_group }, ... }`` - in this case the specified groups will be applied.
      ---See `#format-text-examples`
      -- text_format = function(symbol) end,
      references = { enabled = true, include_declaration = false },
      definition = { enabled = true },
      implementation = { enabled = true },
      ---@type { lsp?: string[], filetypes?: string[] } Disables `symbol-usage.nvim' on certain LSPs or file types.
      disable = { lsp = {}, filetypes = { "lua" } },
      ---@type UserOpts[] See default overridings in `lua/symbol-usage/langs.lua`
      -- filetypes = {},
      ---@type 'start'|'end' At which position of `symbol.selectionRange` the request to the lsp server should start. Default is `end` (try changing it to `start` if the symbol counting is not correct).
      symbol_request_pos = "start", -- Recommended redifine only in `filetypes` override table
      text_format = function(symbol)
        local fragments = {}
        local sep = { "", "" }

        if symbol.references then
          table.insert(fragments, { sep[1], "SymbolUsageRefRound" })
          table.insert(fragments, { "󰌹 " .. tostring(symbol.references), "SymbolUsageRef" })
          table.insert(fragments, { sep[2], "SymbolUsageRefRound" })
        end

        if symbol.definition then
          if #fragments > 0 then
            table.insert(fragments, { " ", "NonText" })
          end
          table.insert(fragments, { sep[1], "SymbolUsageDefRound" })
          table.insert(fragments, { "󰳽 " .. tostring(symbol.definition), "SymbolUsageDef" })
          table.insert(fragments, { sep[2], "SymbolUsageDefRound" })
        end

        if symbol.implementation then
          if #fragments > 0 then
            table.insert(fragments, { " ", "NonText" })
          end
          table.insert(fragments, { sep[1], "SymbolUsageImplRound" })
          table.insert(fragments, { "󰡱 " .. tostring(symbol.implementation), "SymbolUsageImpl" })
          table.insert(fragments, { sep[2], "SymbolUsageImplRound" })
        end

        return fragments
      end,
    },
    keys = {
      {
        "<leader>cS",
        function()
          ---@return boolean True if active, false otherwise
          require("symbol-usage").toggle()
        end,
        desc = "Toggle [c]ode [S]ymbols",
      },
    },
    config = function(_, opts)
      local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end

      vim.api.nvim_set_hl(0, 'SymbolUsageRef', { bg = h('Type').fg, fg = h('CursorLine').bg, bold = true })
      vim.api.nvim_set_hl(0, 'SymbolUsageRefRound', { fg = h('Type').fg })

      vim.api.nvim_set_hl(0, 'SymbolUsageDef', { bg = h('Function').fg, fg = h('CursorLine').bg, bold = true })
      vim.api.nvim_set_hl(0, 'SymbolUsageDefRound', { fg = h('Function').fg })

      vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { bg = h('@parameter').fg, fg = h('CursorLine').bg, bold = true })
      vim.api.nvim_set_hl(0, 'SymbolUsageImplRound', { fg = h('@parameter').fg })
      require('symbol-usage').setup(opts)
    end
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    event = "VeryLazy",
    version = "*",
    dependencies = {
      {
        "SmiteshP/nvim-navic",
        opts = {
          icons = {
            File = " ",
            Module = " ",
            Namespace = " ",
            Package = " ",
            Class = " ",
            Method = " ",
            Property = " ",
            Field = " ",
            Constructor = " ",
            Enum = " ",
            Interface = " ",
            Function = " ",
            Variable = " ",
            Constant = " ",
            String = " ",
            Number = " ",
            Boolean = " ",
            Array = " ",
            Object = " ",
            Key = " ",
            Null = " ",
            EnumMember = " ",
            Struct = " ",
            Event = " ",
            Operator = " ",
            TypeParameter = " ",
          },
          lsp = {
            auto_attach = true,
            preference = nil,
          },
          highlight = true,
          separator = "  ",
          depth_limit = 0,
          depth_limit_indicator = "..",
          safe_output = true,
          lazy_update_context = false,
          click = false,
          format_text = function(text)
            return text
          end,
        },
        config = function(_, opts)
          require("nvim-navic").setup(opts)
        end,
      },
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      theme = "catppuccin-macchiato",
      -- configurations go here
      symbols = {
        -- NOTE: Add a much better icon via nerdfonts
        separator = "",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>tt",
        "<cmd>TodoTrouble<CR>",
        desc = "[T]rouble TODO",
      },
      {
        "<leader>ts",
        "<cmd>TodoTelescope<CR>",
        desc = "Tele[s]cope TODO",
      },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next [T]ODO",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Prev [T]ODO",
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      {
        "<A-t>",
        "<cmd>TroubleToggle<CR>",
        desc = "[T]rouble",
      },
      {
        "<leader>tx",
        "<cmd>TroubleToggle quickfix<CR>",
        desc = "Trouble Fi[x]",
      },
    },
    opts = {},
  },
}
