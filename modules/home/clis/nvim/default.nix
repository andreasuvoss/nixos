{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  inputs,
  ...
}:
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
    # This feels like black magic
    nixpkgs = {
      overlays = [
        (final: prev: {
          vimPlugins = prev.vimPlugins // {
            nvim-autotag = prev.vimUtils.buildVimPlugin {
              name = "nvim-autotag";
              src = inputs.nvim-autotag;
            };
          };
        })
      ];
    };

    programs.neovim =
      let
        toLua = str: "lua << EOF\n${str}\nEOF\n";
        toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
      in
      {
        enable = true;
        withRuby = false;
        withPython3 = false;
        defaultEditor = true;
        extraPackages = with pkgs; [
          nixfmt
          # LSPs
          lua-language-server
          csharp-ls
          rust-analyzer
          typescript-language-server
          vue-language-server
          pyright
          nil
          elixir-ls
          gopls
          docker-compose-language-service
          bicepLanguageServer
        ];

        initLua = ''
          ${builtins.readFile ./settings.lua}
          ${builtins.readFile ./keybindings.lua}
          ${builtins.readFile ./plugins/treesitter.lua}
        '';
        plugins = with pkgs.vimPlugins; [
          {
            type = "lua";
            plugin = nvim-cmp;
            config = builtins.readFile ./plugins/cmp.lua;
          }
          cmp-buffer
          cmp-path
          cmp-nvim-lsp
          cmp_luasnip
          luasnip
          {
            type = "lua";
            plugin = conform-nvim;
            config = "require('conform').setup()";
          }
          {
            type = "lua";
            plugin = nvim-autopairs;
            config = "require('nvim-autopairs').setup()";
          }
          {
            type = "lua";
            plugin = nvim-autotag;
            config = "require('nvim-ts-autotag').setup()";
          }
          {
            type = "lua";
            plugin = nvim-highlight-colors;
            config = "require('nvim-highlight-colors').setup()";
          }
          nvim-web-devicons
          nui-nvim
          plenary-nvim

          {
            type = "lua";
            plugin = comment-nvim;
            config = "require('Comment').setup()";
          }
          {
            type = "lua";
            plugin = dracula-nvim;
            config = "vim.cmd[[colorscheme dracula]]";
          }
          {
            type = "lua";
            plugin = gitsigns-nvim;
            config = builtins.readFile ./plugins/gitsigns.lua;
          }
          {
            type = "lua";
            plugin = undotree;
          }
          {
            type = "lua";
            plugin = which-key-nvim;
          }
          {
            type = "lua";
            plugin = lualine-nvim;
            config = builtins.readFile ./plugins/lualine.lua;
          }
          {
            type = "lua";
            plugin = oil-nvim;
            config = builtins.readFile ./plugins/oil.lua;
          }
          {
            type = "lua";
            plugin = nvim-surround;
            config = "require('nvim-surround').setup()";
          }
          {
            type = "lua";
            plugin = telescope-nvim;
            config = builtins.readFile ./plugins/telescope.lua;
          }
          {
            type = "lua";
            # plugin = nvim-treesitter.withAllGrammars;
            plugin = nvim-treesitter.withPlugins (p: [
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
              p.tree-sitter-html
              p.tree-sitter-tsx
              p.tree-sitter-elixir
              p.tree-sitter-heex
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
            ]);
          }
          {
            type = "lua";
            plugin = nvim-lspconfig;
            config = builtins.readFile ./plugins/lsp.lua;
          }
        ];
      };
    home.sessionVariables.BICEP_LANGSERVER = "${bicepLanguageServer}/Bicep.LangServer.dll";
    home.sessionVariables.VUE_LANGSERVER = "${pkgs-unstable.vue-language-server}/lib/node_modules/@vue/language-server";
  };
}
