return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    input = { enabled = true },
    picer = { enabled = true },
    notifier = { enabled = true },
    scope = { enabled = true },
    sroll = { enabled = true },
  },
}
