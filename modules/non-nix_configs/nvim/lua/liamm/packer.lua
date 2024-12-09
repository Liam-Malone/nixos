return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use({ 'rose-pine/neovim', as = 'rose-pine' })
  use({ 'folke/tokyonight.nvim', as = 'tokyonight' })
  use({ 'karoliskoncevicius/sacredforest-vim', as = 'sacredforest' })
  use({ 'EdenEast/nightfox.nvim', as = 'nightfox' })

  use 'nvim-telescope/telescope.nvim'
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use 'nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'nvim-lua/plenary.nvim'
  use 'mbbill/undotree'
  use 'theprimeagen/harpoon'
  use 'nvim-lualine/lualine.nvim'
  use {
      'mfussenegger/nvim-dap', -- debugger integration
      requires = {
          'rcarriga/nvim-dap-ui',
          'nvim-neotest/nvim-nio' -- dep of dap-ui
      }
  }
  use 'mfussenegger/nvim-jdtls' -- Java LSP Support

  use 'tpope/vim-fugitive' -- git integration
  --LSP CONFIG
  --
  use {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v4.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},     -- Required
      {'hrsh7th/cmp-buffer'},
	  {'hrsh7th/cmp-path'},
	  {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'}, -- Required
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},     -- Required
      {'rafamadriz/friendly-snippets'},
    }
  }

end)
