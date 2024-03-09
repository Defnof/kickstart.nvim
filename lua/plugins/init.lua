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
        alpha_config.button(
          'e',
          '  N[e]w file',
          '<cmd>ene <BAR> startinsert <CR>'
        ),
        alpha_config.button(
          'f',
          '󰈞  [F]ind file',
          '<cmd>Telescope find_files<CR>'
        ),
        alpha_config.button(
          'g',
          '󰜏  [G]rep project',
          '<cmd>Telescope live_grep<CR>'
        ),
        -- alpha_config.button("p", "  Load [P]rojects", "<cmd>SessionManager load_session <CR>"),
        -- alpha_config.button("l", "  [L]oad last project", "<cmd>SessionManager load_last_session <CR>"),
        alpha_config.button(
          'p',
          '  Load [P]rojects',
          '<cmd>Telescope neovim-project discover<CR>'
        ),
        alpha_config.button(
          'l',
          '  [L]oad last project',
          '<cmd>NeovimProjectLoadRecent<CR>'
        ),
      }
      -- disable MRU
      alpha_config.section.mru.val = {}
      alpha_config.section.mru_cwd.val = {}
      alpha_config.nvim_web_devicons.enabled = true
      --
      alpha_config.section.bottom_buttons.val = {
        -- TODO: Finish implementation using MRU or other
        alpha_config.button('L', '󰂖  [L]azy Plugins', '<cmd>Lazy<CR>'),
        alpha_config.button(
          'u',
          '󰚰  [U]pdate plugins',
          '<cmd>Lazy update<CR>'
        ),
        alpha_config.button('c', '  Open [C]onfig', '<cmd>e $MYVIMRC<CR>'),
        alpha_config.button('h', '  Check [h]ealth', '<cmd>checkhealth<CR>'),
        alpha_config.button('q', '󰅚  [Q]uit', '<cmd>qa<CR>'),
      }

      alpha_config.config.opts.setup = function()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'AlphaReady',
          desc = 'Disable status and tabline for alpha',
          callback = function()
            vim.go.laststatus = 0
          end,
        })
        vim.api.nvim_create_autocmd('BufUnload', {
          buffer = 0,
          desc = 'Enable status and tabline after alpha',
          callback = function()
            vim.go.laststatus = 3
          end,
        })
      end

      alpha.setup(alpha_config.config)
    end,
  },

  {
    'coffebar/neovim-project',
    event = 'VimEnter',
    opts = {
      autosave_ignore_dirs = {
        vim.fn.expand '~', -- don't create a session for $aHOME/
        '/tmp',
      },
      last_session_on_startup = false,
      projects = { -- define project roots
        '~/Documents/work/*',
        '~/dotfiles/',
        '~/dotfiles/kickstart',
        '~/Documents/Brain/',
        '~/Documents/playground/*',
        '~/Documents/packages//*',
      },
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append 'globals' -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    config = function(_, opts)
      require('neovim-project').setup(opts)

      local augroup = vim.api.nvim_create_augroup('user_cmds', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        pattern = { 'SessionLoadPost' },
        group = augroup,
        desc = 'Update git env for dotfiles after loading session',
        callback = function()
          require('nvim-tree.api').tree.toggle { focus = false }
        end,
      })
    end,
    keys = {
      {
        '<leader>pl',
        '<cmd>NeovimProjectLoadRecent<CR>',
        desc = '[L]ast Session',
      },
      {
        '<leader>po',
        '<cmd>Telescope neovim-project discover<CR>',
        desc = 'Show [P]rojects',
      },
    },
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim', tag = '0.1.4' },
      { 'Shatur/neovim-session-manager' },
    },
  },
}
