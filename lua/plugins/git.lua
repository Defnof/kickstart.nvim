return {
  -- Git related plugins
  {
    'kdheepak/lazygit.nvim',
    enabled = true,
    event = 'VeryLazy',
    keys = {
      {
        '<A-g>',
        '<cmd>LazyGit<CR>',
        desc = 'LazyGit',
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },

  {
    'NeogitOrg/neogit',
    enabled = false,
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed, not both.
      'nvim-telescope/telescope.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
    },
    opts = {},
    keys = {
      {
        '<A-g>',
        '<cmd>Neogit kind=vsplit<CR>',
        desc = 'Neo[g]it',
      },
    },
  },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        -- add = { text = "" },
        -- change = { text = "󰅫" },
        -- delete = { text = '' },
        -- topdelete = { text = '󰢦' },
        -- changedelete = { text = '' },
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to next hunk' })

        map({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to previous hunk' })

        -- Actions
        -- visual mode
        map('v', '<leader>ghs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>ghr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>ghs', gs.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>ghr', gs.reset_hunk, { desc = 'git reset hunk' })
        map('n', '<leader>ghS', gs.stage_buffer, { desc = 'git Stage buffer' })
        map(
          'n',
          '<leader>ghu',
          gs.undo_stage_hunk,
          { desc = 'undo stage hunk' }
        )
        map('n', '<leader>ghR', gs.reset_buffer, { desc = 'git Reset buffer' })
        map('n', '<leader>ghp', gs.preview_hunk, { desc = 'preview git hunk' })
        map('n', '<leader>ghb', function()
          gs.blame_line { full = false }
        end, { desc = 'git blame line' })
        map(
          'n',
          '<leader>ghd',
          gs.diffthis,
          { desc = 'git diff against index' }
        )
        map('n', '<leader>ghD', function()
          gs.diffthis '~'
        end, { desc = 'git diff against last commit' })

        -- Toggles
        map(
          'n',
          '<leader>gtb',
          gs.toggle_current_line_blame,
          { desc = '[T]oggle git [b]lame line' }
        )
        map(
          'n',
          '<leader>gtd',
          gs.toggle_deleted,
          { desc = '[T]oggle git show [d]eleted' }
        )

        -- Text object
        map(
          { 'o', 'x' },
          'gih',
          ':<C-U>Gitsigns select_hunk<CR>',
          { desc = 'select git hunk' }
        )
      end,
    },
  },
}
