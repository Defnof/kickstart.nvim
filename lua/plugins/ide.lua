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
  { "artemave/workspace-diagnostics.nvim", event = "VeryLazy" },
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
    "simrat39/symbols-outline.nvim",
    enabled = false,
    event = "VeryLazy",
    keys = {
      {
        "<A-s>",
        "<cmd>SymbolsOutline<CR>",
        desc = "Toggle [S]ymbols",
      },
    },
    config = true,
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
        desc = "[T]rouble Fix",
      },
    },
    opts = {},
  },
}
