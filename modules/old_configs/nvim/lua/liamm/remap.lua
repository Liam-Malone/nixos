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

<<<<<<< HEAD
-- put nvim to background 
=======
-- put to background 
>>>>>>> main
vim.keymap.set("n", "<leader>bg", "<C-z>")

-- BUILD SCRIPT INVOKATIONS

-- `build.sh` script binds
-- non-interactive binds
vim.keymap.set("n", "<leader>bb"  , "<cmd>./build.sh <CR>")
vim.keymap.set("n", "<leader>br"  , "<cmd>./build.sh run <CR>")
vim.keymap.set("n", "<leader>bRb" , "<cmd>./build.sh release <CR>")
vim.keymap.set("n", "<leader>bRr" , "<cmd>./build.sh release run <CR>")
vim.keymap.set("n", "<leader>bRr" , "<cmd>./build.sh release run <CR>")

-- interactive binds
vim.keymap.set("n", "<leader>bo"  , "<cmd>./build.sh ") -- allow for adding extra flags/options
vim.keymap.set("n", "<leader>bor" , "<cmd>./build.sh run") -- allow for adding extra flags/options
vim.keymap.set("n", "<leader>bRo" , "<cmd>./build.sh release ")
vim.keymap.set("n", "<leader>bRor", "<cmd>./build.sh release run ")

-- `build.zig` script binds
-- non-interactive binds
vim.keymap.set("n", "<leader>zbb"  , "<cmd>zig build <CR>")
vim.keymap.set("n", "<leader>zbr"  , "<cmd>zig build run <CR>")
vim.keymap.set("n", "<leader>zbt"  , "<cmd>zig build test <CR>")
vim.keymap.set("n", "<leader>zbR"  , "<cmd>zig build -Doptimize=ReleaseSafe <CR>")
vim.keymap.set("n", "<leader>zbRs" , "<cmd>zig build -Doptimize=ReleaseSmall <CR>")
vim.keymap.set("n", "<leader>zbRf" , "<cmd>zig build -Doptimize=ReleaseFast <CR>")
vim.keymap.set("n", "<leader>zbRr" , "<cmd>zig build run -Doptimize=ReleaseSafe <CR>")
vim.keymap.set("n", "<leader>zbRsr", "<cmd>zig build run -Doptimize=ReleaseSmall <CR>")
vim.keymap.set("n", "<leader>zbRfr", "<cmd>zig build run -Doptimize=ReleaseFast <CR>")

-- interactive binds
vim.keymap.set("n", "<leader>zbob"  , "<cmd>zig build ")
vim.keymap.set("n", "<leader>zbor"  , "<cmd>zig build run ")
vim.keymap.set("n", "<leader>zbot"  , "<cmd>zig build test ")
vim.keymap.set("n", "<leader>zboR"  , "<cmd>zig build -Doptimize=ReleaseSafe ")
vim.keymap.set("n", "<leader>zboRs" , "<cmd>zig build -Doptimize=ReleaseSmall ")
vim.keymap.set("n", "<leader>zboRf" , "<cmd>zig build -Doptimize=ReleaseFast ")
vim.keymap.set("n", "<leader>zboRr" , "<cmd>zig build run -Doptimize=ReleaseSafe ")
vim.keymap.set("n", "<leader>zboRsr", "<cmd>zig build run -Doptimize=ReleaseSmall ")
vim.keymap.set("n", "<leader>zboRfr", "<cmd>zig build run -Doptimize=ReleaseFast ")


-- emacs-inspired binds
 -- all <C-w> can be done w spacebar-w
vim.keymap.set("n", "<leader>w", "<C-w>")
vim.keymap.set("n", "<leader>qq", ":x<CR>")
nnoremap("<leader>.", ":find ~/")
nnoremap("<leader>fc", ":find ~/personal/nixos/modules/old_configs/nvim/lua/liamm/remap.lua<CR>")
