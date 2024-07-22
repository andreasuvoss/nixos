{ pkgs, ... }:
{
  programs.neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in
  {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      # LSPs
      lua-language-server
      csharp-ls
      rust-analyzer
      nodePackages.typescript-language-server
      nodePackages.volar
      nil
      gopls
    ];
    extraLuaConfig = ''
      ${builtins.readFile ./settings.lua}
      ${builtins.readFile ./keybindings.lua}
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-cmp;
        config = toLuaFile ./plugins/cmp.lua;
      }
      cmp-buffer
      cmp-path
      cmp-nvim-lsp
      cmp_luasnip
      # TODO: https://github.com/folke/lazydev.nvim
      luasnip
    
      nvim-web-devicons
      nui-nvim
      plenary-nvim
    
      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()";
      }
      {
        plugin = dracula-nvim;
        config = "colorscheme dracula";
      }
      {
        plugin = gitsigns-nvim;
        config = toLuaFile ./plugins/gitsigns.lua;
      }
      {
        plugin = lualine-nvim;
        config = toLuaFile ./plugins/lualine.lua;
      }
      {
        plugin = neo-tree-nvim;
        config = toLuaFile ./plugins/neo-tree.lua;
      }
      {
        plugin = oil-nvim;
        config = toLuaFile ./plugins/oil.lua;
      }
      {
        plugin = nvim-surround;
        config = toLua "require(\"nvim-surround\").setup()";
      }
      {
        plugin = telescope-nvim;
        config = toLuaFile ./plugins/telescope.lua;
      }
      {
        plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-json
          p.tree-sitter-comment
          p.tree-sitter-markdown
          p.tree-sitter-c-sharp
          (pkgs.tree-sitter.buildGrammar {
            language = "bicep";
            version = "0092c7d";
            src = pkgs.fetchFromGitHub {
              owner = "tree-sitter-grammars";
              repo = "tree-sitter-bicep";
              rev = "0092c7d1bd6bb22ce0a6f78497d50ea2b87f19c0";
              hash = "sha256-jj1ccJQOX8oBx1XVKzI53B1sveq5kNADc2DB8bJhsf4=";
            };
          })
        ]));
        config = toLuaFile ./plugins/treesitter.lua;
      }
      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./plugins/lsp.lua;
      }
      # (fromGitHub "HEAD" "lambdalisue/suda.vim")
    ];
  };
}
