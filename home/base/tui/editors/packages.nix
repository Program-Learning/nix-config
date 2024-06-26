{
  pkgs,
  pkgs-stable,
  gomod2nix,
  gradle2nix,
  nixGL,
  ...
}: {
  nixpkgs.config = {
    programs.npm.npmrc = ''
      prefix = ''${HOME}/.npm-global
    '';
  };

  home.packages = with pkgs; [
    #-- haskell
    ghc
    #-- c/c++
    xmake
    cmake
    cmake-language-server
    ccache
    gnumake
    checkmake
    # c/c++ compiler, required by nvim-treesitter!
    gcc
    # c/c++ tools with clang-tools, the unwrapped version won't
    # add alias like `cc` and `c++`, so that it won't conflict with gcc
    # llvmPackages.clang-unwrapped
    clang-tools
    lldb

    #-- python
    nodePackages.pyright # python language server
    poetry
    (python311.withPackages (
      ps:
        with ps; [
          ruff-lsp
          black # python formatter
          # debugpy

          # my commonly used python packages
          jupyter
          ipython
          pandas
          requests
          pyquery
          pyyaml
          boto3

          ## emacs's lsp-bridge dependenciesge
          # epc
          # orjson
          # sexpdata
          # six
          # setuptools
          # paramiko
          # rapidfuzz

          # modules used by Mayuri
          virtualenv
          pip # use in venv "python -m venv .venv" "source .venv/bin/activate"
          tkinter # The standard Python interface to the Tcl/Tk GUI toolkit

          pycryptodome
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
          pygobject3
          pybluez
          pymysql
          redis
          jieba
          # wordcloud
          pandas-datareader
          pyperclip
          fake-useragent
        ]
    ))

    #-- flutter
    # flutter

    #-- rust
    rust-analyzer
    cargo # rust package manager
    rustfmt

    #-- nix
    nil
    nurl

    # rnix-lsp
    # nixd
    statix # Lints and suggestions for the nix programming language
    deadnix # Find and remove unused code in .nix source files
    alejandra # Nix Code Formatter

    #-- golang
    go
    gomodifytags
    gomod2nix.packages.${pkgs.system}.default
    iferr # generate error handling code for go
    impl # generate function implementation for go
    gotools # contains tools like: godoc, goimports, etc.
    gopls # go language server
    delve # go debugger

    # -- java
    jdk17
    # tomcat9
    gradle
    # gradle2nix.packages.${pkgs.system}.gradle2nix
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

    # -- Lisp like Languages
    guile
    racket-minimal
    fnlfmt # fennel

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
    pandoc # document converter
    hugo # static site generator

    #-- Optional Requirements:
    gdu # disk usage analyzer, required by AstroNvim
    (ripgrep.override {withPCRE2 = true;}) # recursively searches directories for a regex pattern

    #-- CloudNative
    nodePackages.dockerfile-language-server-nodejs
    # terraform  # install via brew on macOS
    terraform-ls
    jsonnet
    jsonnet-language-server
    hadolint # Dockerfile linter

    #-- zig
    zls
    #-- verilog / systemverilog
    verible
    gdb
  ];
}
