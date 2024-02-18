-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local alpha_config = require 'alpha.themes.startify'
      alpha_config.section.header.val = {
        [[                                   __                ]],
        [[      ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[     / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[    /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[    \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[     \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
      }
      alpha_config.section.top_buttons.val = {
        alpha_config.button("e", "  N[e]w file", ":ene <BAR> startinsert <CR>"),
        alpha_config.button("f", "󰈞  [F]ind file", "Telescope find_files<CR>"),
        alpha_config.button("g", "󰜏  [G]rep project", "Telescope live_grep"),
        alpha_config.button("p", "  Load [P]rojects", "<cmd>SessionManager load_session <CR>"),
        alpha_config.button("l", "  [L]oad last project", "<cmd>SessionManager load_last_session <CR>"),
      }
      -- disable MRU
      alpha_config.section.mru.val = {}
      alpha_config.section.mru_cwd.val = {}
      alpha_config.nvim_web_devicons.enabled = true
      --
      alpha_config.section.bottom_buttons.val = {
        -- TODO: Finish implementation using MRU or other
        alpha_config.button("L", "󰂖  [L]azy Plugins", "<Cmd>Lazy<CR>"),
        alpha_config.button("c", "  Open [C]onfig", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
        alpha_config.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
      }

      alpha_config.config.opts.setup = function()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          desc = "Disable status and tabline for alpha",
          callback = function()
            vim.go.laststatus = 0
            vim.opt.showtabline = 0
          end,
        })
        vim.api.nvim_create_autocmd("BufUnload", {
          buffer = 0,
          desc = "Enable status and tabline after alpha",
          callback = function()
            vim.go.laststatus = 3
            -- vim.opt.showtabline = 2
          end,
        })
      end

      alpha.setup(alpha_config.config)
    end
  },
  {
    "Shatur/neovim-session-manager",
    cmd = "SessionManager",
    keys = {
      {
        "<leader>pl", "<cmd>SessionManager load_last_session<CR>", desc = "[L]oad last project"
      },
      {
        "<leader>ps", "<cmd>SessionManager save_curent_session<CR>", desc = "[S]ave project"
      },
      {
        "<leader>po", "<cmd>SessionManager load_session<CR>", desc = "L[o]ad [p]roject"
      },
    },
    config = function(opts)
      local Path = require('plenary.path')
      local session_manager = require('session_manager')
      local config_group = vim.api.nvim_create_augroup('SessionGroup', {}) -- A global group for all your config autocommands

      vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = "SessionLoadPost",
        group = config_group,
        callback = function()
          require('nvim-tree.api').tree.toggle(false, true)
        end,
      })

      -- Auto save session
      vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        callback = function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            -- Don't save while there's any 'nofile' buffer open.
            if vim.api.nvim_get_option_value("buftype", { buf = buf }) == 'nofile' then
              return
            end
          end
          session_manager.save_current_session()
        end
      })


      opts['sessions_dir'] = Path:new(vim.fn.stdpath('data'), 'sessions')
      opts['autoload_mode'] = require('session_manager.config').AutoloadMode.Disabled

      session_manager.setup(opts)
    end,
  }
}
