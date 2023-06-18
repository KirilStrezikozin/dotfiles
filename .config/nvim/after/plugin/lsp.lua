-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('recommended')

-- lsp.ensure_installed({
--     'sumneko_lua',
-- })

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()

-- Setup language servers
local lspconfig = require('lspconfig')

lspconfig.pylsp.setup {
  -- This is optional, but allows to create virtual envs from nvim
  host_python = "/usr/bin/python3",
  default_venv_name = "venv", -- For local venv

  settings = {
    pylsp = {
      plugins = {
        autopep8 = {
          enabled = true,
        },
        pycodestyle = {
          enabled = true,
        },
        pyflakes = {
          enabled = false,
          ignore = {'F722'}, -- Doesn't work :(
        },
        flake8 = {
          enabled = true,
          ignore = {'F722'},
        }
      }
    }
  }
}

lspconfig.pyright.setup {
    settings = {
      -- disableLanguageServices = true,

      python = {
        analysis = {
          typeCheckingMode = 'off',
        },
        disable = {'F722'},
      }
    }
}

-- Diagnostics
vim.diagnostic.config({
  update_in_insert = true,
  update_on_insert = true,
  underline = true,
  virtual_text = true,
  show_source = true,
  diagnostics_enable = true,
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
