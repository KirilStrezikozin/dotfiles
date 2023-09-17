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

map('n', "<leader>hp", ":lua require('harpoon.ui').nav_prev()<CR>")
map('n', "<leader>hn", ":lua require('harpoon.ui').nav_next()<CR>")

map('n', "<leader>1", ":lua require('harpoon.ui').nav_file(1)<CR>")
map('n', "<leader>2", ":lua require('harpoon.ui').nav_file(2)<CR>")
map('n', "<leader>3", ":lua require('harpoon.ui').nav_file(3)<CR>")
map('n', "<leader>4", ":lua require('harpoon.ui').nav_file(4)<CR>")
map('n', "<leader>5", ":lua require('harpoon.ui').nav_file(5)<CR>")
map('n', "<leader>6", ":lua require('harpoon.ui').nav_file(6)<CR>")
map('n', "<leader>7", ":lua require('harpoon.ui').nav_file(7)<CR>")
map('n', "<leader>8", ":lua require('harpoon.ui').nav_file(8)<CR>")
map('n', "<leader>9", ":lua require('harpoon.ui').nav_file(9)<CR>")
map('n', "<leader>0", ":lua require('harpoon.ui').nav_file(10)<CR>")
