-- [[ Configure LSP ]]
local map_keybinds = function(bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>ra', vim.lsp.buf.rename, '[R]en[a]me')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Diagnostic keymaps
  nmap('[d', vim.diagnostic.goto_prev, 'Go to previous [d]iagnostic message')
  nmap(']d', vim.diagnostic.goto_next, 'Go to next [d]iagnostic message')
  nmap('<leader>e', vim.diagnostic.open_float, 'Open floating diagnostic messag[e]')
  nmap('<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list')
end


local on_attach = function(_, bufnr)
  return map_keybinds { bufnr }
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


  tsserver = {
    on_attach = function(client, bufnr)
      map_keybinds { bufnr }

      if require "workspace-diagnostics" ~= nil then
        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
      end
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
  },
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

mason_lspconfig.setup_handlers {
  function(server_name)
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
