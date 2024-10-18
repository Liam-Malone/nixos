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

-- put to background 
vim.keymap.set("n", "<leader>bg", "<C-z>")

-- BUILD SCRIPT INVOKATIONS

-- `build.sh` script binds
-- non-interactive binds
vim.keymap.set("n", "<leader>bb"  , ":!./build.sh <CR>")
vim.keymap.set("n", "<leader>br"  , ":!./build.sh run <CR>")
vim.keymap.set("n", "<leader>bRb" , ":!./build.sh release <CR>")
vim.keymap.set("n", "<leader>bRr" , ":!./build.sh release run <CR>")
vim.keymap.set("n", "<leader>bRr" , ":!./build.sh release run <CR>")

-- interactive binds
vim.keymap.set("n", "<leader>bo"  , ":!./build.sh ") -- allow for adding extra flags/options
vim.keymap.set("n", "<leader>bor" , ":!./build.sh run") -- allow for adding extra flags/options
vim.keymap.set("n", "<leader>bRo" , ":!./build.sh release ")
vim.keymap.set("n", "<leader>bRor", ":!./build.sh release run ")

-- `build.zig` script binds
-- non-interactive binds
vim.keymap.set("n", "<leader>zbb"  , ":!zig build <CR>")
vim.keymap.set("n", "<leader>zbr"  , ":!zig build run <CR>")
vim.keymap.set("n", "<leader>zbt"  , ":!zig build test <CR>")
vim.keymap.set("n", "<leader>zbR"  , ":!zig build -Doptimize=ReleaseSafe <CR>")
vim.keymap.set("n", "<leader>zbRs" , ":!zig build -Doptimize=ReleaseSmall <CR>")
vim.keymap.set("n", "<leader>zbRf" , ":!zig build -Doptimize=ReleaseFast <CR>")
vim.keymap.set("n", "<leader>zbRr" , ":!zig build run -Doptimize=ReleaseSafe <CR>")
vim.keymap.set("n", "<leader>zbRsr", ":!zig build run -Doptimize=ReleaseSmall <CR>")
vim.keymap.set("n", "<leader>zbRfr", ":!zig build run -Doptimize=ReleaseFast <CR>")

-- interactive binds
vim.keymap.set("n", "<leader>zbob"  , ":!zig build ")
vim.keymap.set("n", "<leader>zbor"  , ":!zig build run ")
vim.keymap.set("n", "<leader>zbot"  , ":!zig build test ")
vim.keymap.set("n", "<leader>zboR"  , ":!zig build -Doptimize=ReleaseSafe ")
vim.keymap.set("n", "<leader>zboRs" , ":!zig build -Doptimize=ReleaseSmall ")
vim.keymap.set("n", "<leader>zboRf" , ":!zig build -Doptimize=ReleaseFast ")
vim.keymap.set("n", "<leader>zboRr" , ":!zig build run -Doptimize=ReleaseSafe ")
vim.keymap.set("n", "<leader>zboRsr", ":!zig build run -Doptimize=ReleaseSmall ")
vim.keymap.set("n", "<leader>zboRfr", ":!zig build run -Doptimize=ReleaseFast ")


-- emacs-inspired binds
 -- all <C-w> can be done w spacebar-w
vim.keymap.set("n", "<leader>w", "<C-w>")
vim.keymap.set("n", "<leader>qq", ":x<CR>")
nnoremap("<leader>.", ":find ~/")
nnoremap("<leader>fc", ":find ~/personal/nixos/modules/old_configs/nvim/lua/liamm/remap.lua<CR>")
