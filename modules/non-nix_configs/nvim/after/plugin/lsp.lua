local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    -- lsp_zero.default_keymaps({buffer = bufnr})
    --
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end

lsp_zero.extend_lspconfig({
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    lsp_attach = lsp_attach,
    float_border = 'rounded',
    sign_text = true,
})

local lspconfig = require('lspconfig')

require('mason').setup({})

require('mason-lspconfig').setup({
  ensure_installed = {
      'lua_ls',
      'jdtls',
      'clangd',
      'zls',
  },
  handlers = {
      function(server_name)
          require('lspconfig')[server_name].setup({})
      end,

      -- noop is an empty function that doesn't do anything
      clangd = function()
          -- lspconfig.clangd.setup({
          --     cmd = {
          --         'clangd',
          --         '--background-index',
          --         '--clang-tidy',
          --         '--log=verbose',
          --         '--header-interpolation=false', -- clangd doesn't find the files, annoying and unnecessary noise as a result
          --     },
          --     init_options = {
          --         fallbackFlags = {
          --             '-std=c23',
          --             '-std=c++20'
          --         },
          --     },
          -- })
      end,
      jdtls  = function()
          lspconfig.jdtls.setup{}
      end,
      zls    = function()
          lspconfig.zls.setup({})
      end,
      lua_ls = function()
          lspconfig.lua_ls.setup({
              on_init = function(client)
                  if client.workspace_folders then
                      local path = client.workspace_folders[1].name
                      if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
                          return
                      end
                  end

                  client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                      runtime = {
                       -- Tell the language server which version of Lua you're using
                       -- (most likely LuaJIT in the case of Neovim)

                          version = 'LuaJIT'
                      },
                      -- Make the server aware of Neovim runtime files
                      workspace = {
                          checkThirdParty = false,
                          library = {
                              vim.env.VIMRUNTIME
                          }
                      }
                  })
              end,
              settings = {
                  Lua = {
                      diagnostics = {
                          globals = { 'turtle' },
                      },
                  },
              },
          })
      end,
      ols    = function()
          lspconfig.ols.setup({
              single_file_support = true,
              on_attach = function (client, buffer)
                 print('reached ols')
              end
          })
      end,
  }
})


local cmp = require('cmp')
local cmp_select = {behaviour = cmp.SelectBehavior.Select}
cmp.setup({
    sources = {
      { name = 'nvim_lsp' },
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    formatting = lsp_zero.cmp_format(),
})
