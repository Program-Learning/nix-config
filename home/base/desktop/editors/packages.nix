{pkgs, ...}: {
  home.packages = with pkgs;
    [
      #-- c/c++
      cmake
      cmake-language-server
      gnumake
      ccache
      checkmake
      gcc # c/c++ compiler, required by nvim-treesitter!
      llvmPackages.clang-unwrapped # c/c++ tools with clang-tools such as clangd
      lldb

      #-- python
      nodePackages.pyright # python language server
      (python310.withPackages (
        ps:
          with ps; [
            ruff-lsp
            black # python formatter

            ipython
            pandas
            requests
            pyquery
            pyyaml

           ## emacs's lsp-bridge dependenciesge
            epc
            orjson
            sexpdata
            six
            setuptools
            paramiko
            rapidfuzz

            # modules used by Mayuri
            pip # use in venv "python -m venv .venv" "source .venv/bin/activate"

            ipykernel
            jupyterlab
            matplotlib
            numpy
            seaborn
            networkx
            beautifulsoup4
            selenium
            urllib3
            pyclip
            pybluez
            pymysql
            jieba
            # wordcloud
            pandas-datareader
            pyperclip
          ]
      ))

      #-- rust
      rust-analyzer
      cargo # rust package manager
      rustfmt

      #-- zig
      zls

      #-- nix
      nil
      rnix-lsp
      # nixd
      statix # Lints and suggestions for the nix programming language
      deadnix # Find and remove unused code in .nix source files
      alejandra # Nix Code Formatter

      #-- golang
      go
      gomodifytags
      iferr # generate error handling code for go
      impl # generate function implementation for go
      gotools # contains tools like: godoc, goimports, etc.
      gopls # go language server
      delve # go debugger

      # -- java
      jdk17
      gradle
      maven
      spring-boot-cli

      #-- lua
      stylua
      lua-language-server

      #-- bash
      nodePackages.bash-language-server
      shellcheck
      shfmt

      #-- javascript/typescript --#
      nodePackages.nodejs
      nodePackages.typescript
      nodePackages.typescript-language-server
      # HTML/CSS/JSON/ESLint language servers extracted from vscode
      nodePackages.vscode-langservers-extracted
      nodePackages."@tailwindcss/language-server"
      emmet-ls

      #-- CloudNative
      nodePackages.dockerfile-language-server-nodejs
      # terraform  # install via brew on macOS
      terraform-ls
      jsonnet
      jsonnet-language-server
      hadolint # Dockerfile linter

      # -- Lisp like Languages
      guile
      racket-minimal
      fnlfmt  # fennel

      #-- Others
      taplo # TOML language server / formatter / validator
      nodePackages.yaml-language-server
      sqlfluff # SQL linter
      actionlint # GitHub Actions linter
      buf # protoc plugin for linting and formatting
      proselint # English prose linter

      #-- Misc
      tree-sitter # common language parser/highlighter
      nodePackages.prettier # common code formatter
      marksman # language server for markdown
      glow # markdown previewer
      fzf

      #-- Optional Requirements:
      gdu # disk usage analyzer, required by AstroNvim
      (ripgrep.override {withPCRE2 = true;}) # recursively searches directories for a regex pattern
    ]
    ++ (
      if pkgs.stdenv.isDarwin
      then []
      else [
        #-- verilog / systemverilog
        verible
        gdb
      ]
    );
}
