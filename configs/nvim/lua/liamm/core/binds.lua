local remap = require("liamm.core.keymap")
local nnoremap = remap.nnoremap
local vnoremap = remap.vnoremap

-- Normal Mode Mappings
nnoremap("<leader>pv", "<cmd>Ex<CR>")
nnoremap("<leader>tt", "<cmd>TSContextToggle<CR>")
nnoremap("J", "mzJ`z")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("<leader>bg", "<C-z>")
nnoremap("<leader>y", "\"+y")
nnoremap("<leader>Y", "\"+Y")
nnoremap("<leader>x", "<cmd>!chmod +x %<CR>", {silent = true})

nnoremap("<leader>w", "<C-w>")

nnoremap("<leader>qq", ":x<CR>")
nnoremap("<leader>.", ":find ~/")
nnoremap("<leader>oc", ":find ~/.config/nvim/lua/liamm/core/binds.lua<CR>")
nnoremap("<leader>bs", ":lua Build()<CR>")

-- Visual Mode Mappings
vnoremap("K", ":m '<-2<CR>gv=gv")
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("<leader>y", "\"+y")

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
