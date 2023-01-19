local function map(mode, lhs, rhs, opts)
local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<leader>pf", "<cmd>Telescope find_files<CR>")
map("n", "<leader>ps", "<cmd>Telescope grep_string<CR>")
map("n", "<leader>pzf", "<cmd>Telescope current_buffer_fuzzy_find<CR>")
map("n", "<leader>pgc", "<cmd>Telescope git_commits<CR>")
map("n", "<leader>pgb", "<cmd>Telescope git_branches<CR>")
map("n", "<leader>pgs", "<cmd>Telescope git_status<CR>")

