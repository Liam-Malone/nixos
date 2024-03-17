local nnoremap = require("liamm.keymap").nnoremap

nnoremap("<leader>pv", "<cmd>Ex<CR>")
nnoremap("<leader>tv", "<cmd>ToggleTerm<CR>")
nnoremap("<leader>tt", "<cmd>TSContextToggle<CR>")

vim.keymap.set("v", "<leader>ss", ":CarbonNow<CR>", { silent = true })

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", {silent = true})

-- put nvim to background 
vim.keymap.set("n", "<leader>z", "<C-z>")

-- emacs-inspired binds
 -- all <C-w> can be done w spacebar-w
vim.keymap.set("n", "<leader>w", "<C-w>")
vim.keymap.set("n", "<leader>qq", ":x<CR>")
nnoremap("<leader>.", ":find ~/")
nnoremap("<leader>fc", ":find ~/.config/nvim/lua/liamm/remap.lua<CR>")
