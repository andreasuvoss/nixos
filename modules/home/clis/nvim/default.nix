{ pkgs, pkgs-unstable, lib, config, ... }:
let
  bicepLanguageServer = pkgs.stdenv.mkDerivation rec {
    pname = "bicep-langserver";
    version = "0.36.177";

    src = pkgs.fetchurl {
      url = "https://github.com/Azure/bicep/releases/download/v${version}/bicep-langserver.zip";
      sha256 = "sha256-2W/hRGfKo7cvRv3SDRVe3Pd5nVat36QrC3rjOAqxSNw=";
    };

    buildInputs = [ pkgs.unzip ];

    unpackPhase = "unzip $src -d $out";
    installPhase = ''
      mkdir -p $out/bin
      cp -r * $out/bin
    '';

  };
in
{
  options = {
    nvim.enable = lib.mkEnableOption "enable nvim";
  };
  config = lib.mkIf config.nvim.enable {
    programs.neovim = 
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in
    {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        nixfmt-rfc-style
        # LSPs
        lua-language-server
        csharp-ls
        rust-analyzer
        typescript-language-server
        vue-language-server
        pyright
        nil
        gopls
        docker-compose-language-service
        bicepLanguageServer
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
        # TODO: https://github.com/stevearc/conform.nvim
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
          plugin = undotree;
        }
        {
          plugin = which-key-nvim;
        }
        {
          plugin = nvim-dap-virtual-text;
        }
        {
          plugin = nvim-dap-ui;
        }
        {
          plugin = nvim-dap;
          config = toLuaFile ./plugins/dap.lua;
        }
        {
          plugin = lualine-nvim;
          config = toLuaFile ./plugins/lualine.lua;
        }
        # {
        #   plugin = neo-tree-nvim;
        #   config = toLuaFile ./plugins/neo-tree.lua;
        # }
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
            p.tree-sitter-markdown-inline
            p.tree-sitter-c-sharp
            p.tree-sitter-python
            p.tree-sitter-yaml
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
    home.sessionVariables.BICEP_LANGSERVER = "${bicepLanguageServer}/Bicep.LangServer.dll";
    home.sessionVariables.VUE_LANGSERVER = "${pkgs-unstable.vue-language-server}/lib/node_modules/@vue/language-server";
  };
}
