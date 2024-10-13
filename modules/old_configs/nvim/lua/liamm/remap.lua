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
vim.keymap.set("n", "<leader>bg", "<C-z>")


-- invoke build scripts
-- `build.sh`
vim.keymap.set("n", "<leader>bo",  ":!./build.sh ") -- Interactive for adding flags/options
vim.keymap.set("n", "<leader>bb",  ":!./build.sh <CR>")
vim.keymap.set("n", "<leader>br",  ":!./build.sh run<CR>")
vim.keymap.set("n", "<leader>bR",  ":!./build.sh release<CR>")
vim.keymap.set("n", "<leader>bRr", ":!./build.sh release run<CR>")

-- zig build
vim.keymap.set("n", "<leader>zbo",  ":!zig build -D") -- Interactive for adding flags/options
vim.keymap.set("n", "<leader>zbb",  ":!zig build <CR>")
vim.keymap.set("n", "<leader>zbr",  ":!zig build run<CR>")
vim.keymap.set("n", "<leader>zbR",  ":!zig build -Doptimize=ReleaseSafe <CR>")
vim.keymap.set("n", "<leader>zbRr", ":!zig build -Doptimize=ReleaseSafe run<CR>")
vim.keymap.set("n", "<leader>zbt",  ":!zig build -Dtarget=") -- Interactive to add target/other flags
vim.keymap.set("n", "<leader>zbtR", ":!zig build -Doptimize=ReleaseSafe -Dtarget=") -- Interactive to add target/other flags


-- emacs-inspired binds
 -- all <C-w> can be done w spacebar-w
vim.keymap.set("n", "<leader>w", "<C-w>")
vim.keymap.set("n", "<leader>qq", ":x<CR>")
nnoremap("<leader>.", ":find ~/")
nnoremap("<leader>fc", ":find ~/personal/nixos/modules/old_configs/nvim/lua/liamm/remap.lua<CR>")
