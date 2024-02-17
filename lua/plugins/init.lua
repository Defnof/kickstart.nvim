-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local config = require 'alpha.themes.dashboard'.config
      require 'alpha'.setup(config)
    end
  },
  {
    "Shatur/neovim-session-manager",
    keys = {
      {
        "<leader>Sl", "<cmd>SessionManager load_last_session<CR>", desc = "[L]oad last session"
      },
      {
        "<leader>Ss", "<cmd>SessionManager save_curent_session<CR>", desc = "[S]ave session"
      },
      {
        "<leader>So", "<cmd>SessionManager load_session<CR>", desc = "L[o]ad session"
      },
    },
    config = function(opts)
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


      opts['autoload_mode'] = require('session_manager.config').AutoloadMode.Disabled

      session_manager.setup(opts)
    end,
  }
}
