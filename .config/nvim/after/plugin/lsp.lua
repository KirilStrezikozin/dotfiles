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
          ignore = {'F722', 'W503'},
        },
        pycodestyle = {
          enabled = false,
          ignore = {'F722', 'W503'},
        },
        pyflakes = {
          enabled = false,
          ignore = {'F722', 'W503'}, -- Doesn't work :(
        },
        flake8 = {
          enabled = true,
          ignore = {'F722', 'W503'},
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
        disable = {'F722', 'W503'},
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

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
