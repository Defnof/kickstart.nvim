-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local Path = require('plenary.path')
      local alpha = require 'alpha'
      local startify = require 'alpha.themes.startify'
      startify_session_dir = Path:new(vim.fn.stdpath('data'), 'sessions')
      startify.section.header.val = {
        [[                                   __                ]],
        [[      ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[     / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[    /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[    \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[     \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
      }
      startify.section.top_buttons.val = {
        startify.button("e", "  N[e]w file", ":ene <BAR> startinsert <CR>"),
        startify.button("f", "󰈞  [F]ind file", ":ene <BAR> startinsert <CR>"),
        startify.button("g", "󰜏  [G]rep project", ":ene <BAR> startinsert <CR>"),
        startify.button("s", "  [S]how session", "<cmd>SessionManager load_session <CR>"),
        startify.button("l", "  [L]oad last session", "<cmd>SessionManager load_last_session <CR>"),
      }
      -- disable MRU
      startify.section.mru.val = { { type = "padding", val = 0 } }
      -- disable MRU cwd
      startify.section.mru_cwd.val = { { type = "padding", val = 0 } }
      -- disable nvim_web_devicons
      startify.nvim_web_devicons.enabled = true
      -- startify.nvim_web_devicons.highlight = false
      -- startify.nvim_web_devicons.highlight = 'Keyword'
      --
      startify.section.bottom_buttons.val = {
        -- TODO: Finish implementation using MRU or other
        startify.button("1", "󰛦  Work Project #1", ":qa<CR>"),
        startify.button("2", "󰛦  Work Project #2", ":qa<CR>"),
        startify.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
      }
      -- startify.section.footer.val = {
      --   { type = "text", val = "by Defnof" },
      -- }
      -- ignore filetypes in MRU

      startify.mru_opts.ignore = function(path, ext)
        return
            (string.find(path, "COMMIT_EDITMSG"))
            or (vim.tbl_contains(default_mru_ignore, ext))
      end
      alpha.setup(startify.config)
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
