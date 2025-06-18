local map = require("liamm.core.keymap").nnoremap
local vmap = require("liamm.core.keymap").vnoremap

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local opts = { noremap = true, silent = true }
    local on_attach = function(client, bufnr)
      opts.buffer = bufnr

      opts.desc = "Show LSP References"
      map("gR", "<cmd>Telescope lsp_references<CR>", opts)

      opts.desc = "Go To Declaration"
      map("gD", vim.lsp.buf.declaration, opts)

      opts.desc = "Show LSP Definition"
      map("gd", "<cmd>Telescope lsp_definitions<CR>", opts)

      opts.desc = "Show LSP Type Definitions"
      map("gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

      opts.desc = "Show LSP Implementations"
      map("gi", "<cmd>Telescope lsp_implementations<CR>", opts)

      opts.desc = "See Available Code Actions"
      map("<leader>ca", vim.lsp.buf.code_action, opts)
      vmap("<leader>ca", vim.lsp.buf.code_action, opts)

      opts.desc = "Smart Rename"
      map("<leader>rn", vim.lsp.buf.rename, opts)

      opts.desc = "Show Buffer Diagnostics"
      map("<leader>vD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

      opts.desc = "Show Line Diagnostics"
      map("<leader>vd", vim.diagnostic.open_float, opts)

      opts.desc = "Go To Prev Diagnostic"
      map("[d", "<cmd>vim.diagnostic.jump({ count = 1, float = true })<CR>", opts)

      opts.desc = "Go To Next Diagnostic"
      map("]d", "<cmd>vim.diagnostic.jump({ count = -1, float = true })<CR>", opts)

      opts.desc = "Show Documentation For Cursor Hover"
      map("K", vim.lsp.buf.hover, opts)

      opts.desc = "Show Documentation For Cursor Hover"
      map("<leader>rs", "<cmd>LspRestart<CR>", opts)
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    local signs = {
      Error = ' ',
      Warn = ' ',
      Info = ' ',
      Hint = 'H',
    }

    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    lspconfig["zls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["rnix"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostic = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    lspconfig["ols"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      single_file_support = true,
    })
  end,
}
