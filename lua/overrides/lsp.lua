-- [[ Configure LSP ]]
local map_lsp_keybinds = require('utils.mapping').map_lsp_keybinds

local on_attach = function(client, bufnr)
  return map_lsp_keybinds(bufnr)
end -- mason-lspconfig requires that these setup functions are called in this order

-- before setting up the servers.
require('mason').setup()

local lsputils = require 'lspconfig.util'

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  gopls = { name = 'gopls' },
  pyright = { name = 'pyright' },
  biome = {
    name = 'biome',
    root_dir = lsputils.root_pattern 'biome.json',
    single_file_support = false,
    settings = {
      filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescript.tsx',
        'typescriptreact',
      },
    },
  },
  eslint = {
    name = 'eslint-lsp',
    root_dir = lsputils.root_pattern '.eslintrc.js',
    single_file_support = false,
    settings = {
      filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescript.tsx',
        'typescriptreact',
      },
    },
  },
  tailwindcss = {
    name = 'tailwindcss-language-server',
    filetypes = {
      'typescriptreact',
    },
  },
  jsonls = {
    name = 'json-lsp',
    settings = {
      json = {
        format = {
          enable = true,
        },
        validate = { enable = true },
      },
    },
  },
  bashls = { name = 'bash-language-server' },
  lua_ls = {
    name = 'lua-language-server',
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
local ensure_installed = {
  'biome',
  'codespell',
  'isort',
  'stylua',
  'shfmt',

  -- additional servers that we don't want to setup via lspconfig
  'typescript-language-server',
  'rust-analyzer',
}

local mason_lsp = {}

-- Get the mason name for mason-tool-installer
for server, settings in pairs(servers) do
  if settings['name'] == nil then
    return
  end

  table.insert(ensure_installed, settings['name'])
  settings['name'] = nil
end

vim.list_extend(ensure_installed, mason_lsp)

-- Ensure the servers above are installed
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

-- NOTE: For each server setup
for server, settings in pairs(servers) do
  if settings['on_attach'] == nil then
    settings['on_attach'] = on_attach
  end

  if settings['capabilities'] == nil then
    settings['capabilities'] = capabilities
  end

  if settings['filetypes'] == nil then
    settings['filetypes'] = servers[server].filetypes
  end

  require('lspconfig')[server].setup(settings)
end
