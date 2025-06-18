return {
  -- the colorscheme should be available when starting Neovim
  {
    "sainnhe/sonokai",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme sonokai]])
    end,
  },

  {
    "p00f/alabaster.nvim",
    name = "alabaster",
  },

  -- Other colorschemes
  {
    "karoliskoncevicius/sacredforest-vim",
    lazy = false,
    name = "sacredforest"
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    name = "tokyonight",
  },
}
