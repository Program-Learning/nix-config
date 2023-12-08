{
  pkgs,
  pkgs-unstable,
  nur-program-learning,
  ...
}: {
  #############################################################
  #
  #  Basic settings for development environment
  #
  #  Please avoid to install language specific packages here(globally),
  #  instead, install them:
  #     1. per IDE, such as `programs.neovim.extraPackages`
  #     2. per-project, using https://github.com/the-nix-way/dev-templates
  #
  #############################################################

  home.packages = with pkgs; [
    # Expose localhost to the world
    #nodePackages_latest.localtunnel

    man-pages
    man-pages-posix

    # DO NOT install build tools for C/C++ and others, set it per project by devShell instead
    gnumake # used by this repo, to simplify the deployment
    gradle
    maven
    spring-boot-cli

    nur-program-learning.packages.${pkgs.system}.clang_dev_env_fhs

    (python3.withPackages (
      ps:
        with ps; [
          ipykernel
          #jupyterlab
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
          pip # use in venv "python -m venv .venv" "source .venv/bin/activate"

          ipython
          pandas
          requests
          pyquery
          pyyaml
        ]
    ))

    cargo # rust package manager
    go
    jdk17
    guile # scheme language

    # db related
    dbeaver
    mycli
    pgcli
    mongosh
    sqlite

    # embedded development
    minicom

    # misc
    pkgs-unstable.
    glow # markdown previewer
    fzf
    gdu # disk usage analyzer, required by AstroNvim
    ripgrep # fast search tool, required by AstroNvim's '<leader>fw'(<leader> is space key)
    bfg-repo-cleaner # remove large files from git history
    k6 # load testing tool
    mitmproxy # http/https proxy tool
    tcpdump
    protobuf # protocol buffer compiler
  ] ++ (if pkgs.stdenv.isLinux then [
    # Automatically trims your branches whose tracking remote refs are merged or gone
    # It's really useful when you work on a project for a long time.
    git-trim

    # need to run `conda-install` before using it
    # need to run `conda-shell` before using command `conda`
    # conda is not available for MacOS
    conda

    mitmproxy # http/https proxy tool
    insomnia # REST client
    wireshark # network analyzer
  ] else [])
  ++ [    
    nur-program-learning.packages.${pkgs.system}.wechat_dev_tools_appimage
    nur-program-learning.packages.${pkgs.system}.wechat_dev_tools_deb
    ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableZshIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
