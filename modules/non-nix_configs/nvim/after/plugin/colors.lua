function ColorMyTerminal(color)
    color = color or "tokyonight-night"
    vim.cmd.colorscheme(color)

    vim.cmd("hi ColorColumn ctermbg=0 guibg=purple")
    vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
    vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
end

vim.cmd.colorscheme("tokyonight-night")
