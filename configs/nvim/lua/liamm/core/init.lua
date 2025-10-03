require("liamm.core.binds")
require("liamm.core.keymap")
require("liamm.core.options")

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.h",
    callback = function()
        vim.bo.filetype = "c"
    end,
})
