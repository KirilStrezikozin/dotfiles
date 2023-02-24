-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
    'sumneko_lua',
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()

require'py_lsp'.setup {
  -- This is optional, but allows to create virtual envs from nvim
  host_python = "/usr/bin/python3",
  default_venv_name = ".venv" -- For local venv
}

vim.diagnostic.config({
  virtual_text = false
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

