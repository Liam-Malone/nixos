local map = require("liamm.core.keymap").nnoremap
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  config = function()
    local harpoon = require("harpoon")
    ---@diagnostic disable-next-line: missing-parameter
    harpoon:setup()
    map("<leader>a", function() harpoon:list():add() end)
    map("<c-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    map("<c-h>", function() harpoon:list():select(1) end)
    map("<c-j>", function() harpoon:list():select(2) end)
    map("<c-k>", function() harpoon:list():select(3) end)
    map("<c-l>", function() harpoon:list():select(4) end)
  end,
}
