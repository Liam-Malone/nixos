return {
  -- which-key... will setup at some point
  {
    "folke/which-key.nvim",
    lazy = true,
  },

  -- statup time tracking
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- completions
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        completion = {
          completeopt = "menu,meuone,preview,noselect",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- scroll preview forward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- scroll preview backward
          ['<C-y>'] = cmp.mapping.confirm({ select = false }),
          ['<C-c>'] = cmp.mapping.abort(),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- lsp completions
          { name = "luasnip" },  -- snippets
          { name = "buffer" },   -- text within buffer
          { name = "path" },     -- filesystem paths
        }),
      })
    end,
  },

  -- mason
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup({})

      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls",
          "zls",
          "ols",
          "rnix",
        },
        automatic_installation = true, -- auto-install configured servers
        automatic_enable = false,
      })
    end,
  },

  -- cats
  -- {
  --   "Panda-d3v/cute-cat.nvim",
  --   opts = {
  --     status = false,
  --   },
  -- }
}
