{ pkgs, ... }:

{
  programs.neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs; [
        vimPlugins.rose-pine
        vimPlugins.telescope-nvim
        vimPlugins.nvim-treesitter
        vimPlugins.nvim-treesitter-context
        vimPlugins.plenary-nvim
        vimPlugins.undotree
        vimPlugins.harpoon
        vimPlugins.lualine-nvim
        vimPlugins.vim-fugitive
        vimPlugins.lsp-zero-nvim
        vimPlugins.nvim-lspconfig
        vimPlugins.nvim-cmp
        vimPlugins.cmp-path
        vimPlugins.cmp-buffer
        vimPlugins.cmp_luasnip
        vimPlugins.cmp-nvim-lsp
        vimPlugins.cmp-nvim-lua
        vimPlugins.luasnip
        vimPlugins.friendly-snippets
      ];
  };
}
