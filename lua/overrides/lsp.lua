-- [[ Configure LSP ]]
local map_lsp_keybinds = require "utils.mapping".map_lsp_keybinds

local on_attach = function(client, bufnr)
  return map_lsp_keybinds(bufnr)
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()


-- NOTE: TSServer methods
local function execute_ts_command(command)
  return function()
    local params = {
      command = "_typescript." .. command,
      arguments = {
        vim.api.nvim_buf_get_name(0),
      },
    }

    vim.lsp.buf.execute_command(params)
  end
end

local lsputils = require "lspconfig.util"

local tsserver = {
  on_attach = function(client, bufnr)
    -- require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
    map_lsp_keybinds(bufnr)
  end,
  -- NOTE: Settings for inlay hints for JS and TS
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "absolute",
      importModuleSpecifierEnding = "minimal",
    },
  },
  commands = {
    OrganizeImports = {
      execute_ts_command "organizeImports",
      description = "Organize Imports",
    },
    RemoveUnusedImports = {
      execute_ts_command "removeUnused",
      description = "Remove Unused Imports",
    },
    FixAll = {
      execute_ts_command "fixAll",
      description = "Fix All",
    },
  },
}

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
  -- gopls = {},
  -- pyright = {},
  biome = {
    root_dir = lsputils.root_pattern "biome.json",
    single_file_support = false,
    settings = {
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescript.tsx",
        "typescriptreact",
      },
    },
  },
  eslint = {
    root_dir = lsputils.root_pattern ".eslintrc.js",
    single_file_support = false,
    settings = {
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescript.tsx",
        "typescriptreact",
      },
    },
  },
  tailwindcss = {
    filetypes = {
      "typescriptreact",
    },
  },
  -- WARN: Deprecated, replaced by typescript-tools.nvim
  tsserver = tsserver,
  jsonls = {
    settings = {
      json = {
        format = {
          enable = true,
        },
        validate = { enable = true },
      },
    },
  },
  bashls = {},
  rust_analyzer = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
  lua_ls = {
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

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

local in_table = function(table, value)
  for _, v in pairs(table) do
    if (v == value) then
      return true
    end
  end
  return false
end

mason_lspconfig.setup_handlers {
  function(server_name)
    -- NOTE: Let server be handled by external dependencies
    if in_table({ "rust_analyzer", "tsserver" }, server_name) then
      return
    end

    -- NOTE: Add defaults
    local settings = servers[server_name]

    if settings['on_attach'] == nil then
      settings['on_attach'] = on_attach
    end

    if settings['capabilities'] == nil then
      settings['capabilities'] = capabilities
    end

    if settings['filetypes'] == nil then
      settings['filetypes'] = servers[server_name].filetypes
    end

    require('lspconfig')[server_name].setup(settings)
  end,
}
