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

-- DAP debugger
local dap = require('dap')

vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F10>', function() dap.step_over() end)
vim.keymap.set('n', '<F11>', function() dap.step_into() end)
vim.keymap.set('n', '<F12>', function() dap.step_out() end)
vim.keymap.set('n', '<Leader>bp', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)

-- BUILD SCRIPT INVOKATIONS
-- generic build function
local function set(list)
    local _set = {}
    for _, l in ipairs(list) do
        _set[l] = true
    end
    return _set
end

-- TODO: add support for passing flags
function Build()
    local out_buf = vim.api.nvim_create_buf(false, true)

    local build_scripts = set(vim.fs.find({ "build.sh", "build.zig", "build.bat" }, { upward = true, type = "file", path = "." }))
    local output = "[No Build Output]"

    if build_scripts['build.zig'] then
        vim.cmd('echo "Running build.zig"')
        output = vim.fn.system({ 'zig', 'build' })
    else
        if jit.os == 'Windows' and build_scripts['build.bat'] then
            output = vim.fn.system({ 'build', '' })
        elseif build_scripts['build.sh'] then
            output = vim.fn.system({ './build.sh', '' })
        else
        end
    end
    vim.api.nvim_buf_set_lines(out_buf, -1, -1, true, {"[ Build Output ]"})
    vim.api.nvim_buf_set_lines(out_buf, -1, -1, true, vim.split(output, '\n'))

    local window = vim.api.nvim_open_win(out_buf, false, {
        split = 'right',
        win   = 0,
        width = math.floor(vim.o.columns * 0.35),
        style = 'minimal',
    })
    vim.api.nvim_set_current_win(window)

    -- Keybind to close the window on pressing Enter
    vim.api.nvim_buf_set_keymap(out_buf, 'n', '<CR>', '', {
        noremap = true,
        silent = true,
        callback = function()
            vim.api.nvim_win_close(window, true)
        end
    })
end

-- TODO: add support for passing flags
vim.keymap.set("n", "<leader>bs", ":lua Build()<CR>")

-- specific build scipt options

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
