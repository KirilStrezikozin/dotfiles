local function map(mode, lhs, rhs, opts)
local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


-- get me to netrw RIGHT NOW
map("n", "<leader>pv", "<cmd>Ex<CR>")

-- centering views
map('n', "<C-d>", "<C-d>zz")
map('n', "<C-u>", "<C-u>zz")
map('n', "n", "nzz")
map('n', "N", "Nzz")

-- clear highlights
map('n', "<C-l>", "<cmd>noh<CR>")

-- return cursor to the last position
map('n', "rr", "'.zz")

-- yp to instantly paste the current line below
map('n', "yp", "yyp")

-- move things around
map("v", "K", ":m '>-2<CR>gv=gv")
map("v", "J", ":m '<+1<CR>gv=gv")

-- paste without losing what was in the log
map("v", "<leader>p", "\"_dP")

-- type in the text to current replace the current word with
-- in the entire file
map("n", "<leader>S", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
-- in the line I'm on
map("n", "<leader>s", ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
