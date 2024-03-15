return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  --themes ---- commenting out ones I'm not actively using
  --use ({'EdenEast/nightfox.nvim' })
  --use 'rebelot/kanagawa.nvim'                   --not too bad a theme
  use({ 'rose-pine/neovim', as = 'rose-pine' }) --pretty nice themes
  --end themes


  --use 'Tetralux/odin.vim' --odin lang syntax highlighting
  --use 'rust-lang/rust.vim' // don't need this anymore
  use 'nvim-telescope/telescope.nvim'
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use 'nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'nvim-lua/plenary.nvim'
  use 'mbbill/undotree'
  use 'theprimeagen/harpoon'
  use 'nvim-lualine/lualine.nvim'
  use 'tpope/vim-fugitive' -- git integration
  --LSP CONFIG
  --
  use {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {                                      -- Optional
        'williamboman/mason.nvim',
        run = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
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

  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end}
end)
