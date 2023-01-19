local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

local function map(mode, lhs, rhs, opts)
local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', "<C-h>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
map('n', "<leader>n", ":lua require('harpoon.mark').add_file()<CR>")
map('n', "<leader>m", ":lua require('harpoon.mark').rm_file()<CR>")

map('n', "<leader>1", ":lua require('harpoon.ui').nav_prev()<CR>")
map('n', "<leader>2", ":lua require('harpoon.ui').nav_next()<CR>")

