-- vim.cmd("colorscheme ")
-- require("github-theme").setup({
--   theme_style = "dark",
--   function_style = "italic",
--   sidebars = {"qf", "vista_kind", "terminal", "packer"},
-- 
--   -- Change the "hint" color to the "orange" color, and make the "error" color bright red
--   colors = {hint = "orange", error = "#ff0000"},
-- 
--   dark_float = true,
--   dark_sidebar = true,
--   hide_end_of_buffer = true,
--   transparent = true,
-- 
--   comment_style = "italic",
--   variable_style = "italic",
-- 
--   -- Overwrite the highlight groups
--   overrides = function(c)
--     return {
--       htmlTag = {fg = c.red, bg = "#282c34", sp = c.hint, style = "underline"},
--       DiagnosticHint = {link = "LspDiagnosticsDefaultHint"},
--       -- this will remove the highlight groups
--       TSField = {},
--     }
--   end
-- })

function SetColorscheme(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    -- set transparent bg
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

SetColorscheme()
