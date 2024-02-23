-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '-L',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    selection_strategy = 'reset',
    sorting_strategy = 'ascending',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require('telescope.sorters').get_fuzzy_file,
    file_ignore_patterns = { 'node_modules' },
    generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
    path_display = { 'truncate' },
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
      n = { ['q'] = require('telescope.actions').close },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown {
        -- even more opts
      },

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    },
    import = {
      -- Add imports to the top of the file keeping the cursor in place
      insert_at_top = true,
      -- Support additional languages
      custom_languages = {
        {
          -- The regex pattern for the import statement
          regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
          -- The Vim filetypes
          filetypes = { 'typescript', 'typescriptreact', 'javascript', 'react' },
          -- The filetypes that ripgrep supports (find these via `rg --type-list`)
          extensions = { 'js', 'ts' },
        },
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
pcall(require('telescope').load_extension, 'import')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist(
    'git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel'
  )[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set(
  'n',
  '<leader>f?',
  require('telescope.builtin').oldfiles,
  { desc = '[?] Find recently opened files' }
)
vim.keymap.set(
  'n',
  '<leader><space><space>',
  require('telescope.builtin').buffers,
  { desc = '[ ] Find existing buffers' }
)
vim.keymap.set('n', '<leader>f/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(
    require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    }
  )
end, { desc = '[?] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
-- vim.keymap.set('n', '<leader>f/', telescope_live_grep_open_files, { desc = '[Find] [/] in Open Files' })
vim.keymap.set(
  'n',
  '<leader>fs',
  require('telescope.builtin').builtin,
  { desc = '[F]ind [S]elect Telescope' }
)
-- vim.keymap.set('n', '<leader>ff', require('telescope.builtin').git_files, { desc = '[F]ind Git [F]iles' })
vim.keymap.set(
  'n',
  '<leader>ff',
  require('telescope.builtin').find_files,
  { desc = '[F]ind [F]iles' }
)
-- vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
-- vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set(
  'n',
  '<leader>fw',
  require('telescope.builtin').live_grep,
  { desc = '[F]ind by [G]rep' }
)
vim.keymap.set(
  'n',
  '<leader>fg',
  ':LiveGrepGitRoot<cr>',
  { desc = '[F]ind by [G]rep on Git Root' }
)
vim.keymap.set(
  'n',
  '<leader>fd',
  require('telescope.builtin').diagnostics,
  { desc = '[F]ind [D]iagnostics' }
)
vim.keymap.set(
  'n',
  '<leader>ci',
  '<cmd>Telescope import<CR>',
  { desc = '[C]ode [I]mport' }
)
-- vim.keymap.set('n', '<leader>fr', require('telescope.builtin').resume, { desc = '[F]ind [R]esume' })
