{
  pkgs,
  pkgs-unstable,
  ...
}: {
  #############################################################
  #
  #  Basic settings for development environment
  #
  #  Please avoid to install language specific packages here(globally),
  #  instead, install them independently using dev-templates:
  #     https://github.com/the-nix-way/dev-templates
  #
  #############################################################

  home.packages = with pkgs; [
    pkgs-unstable.devbox

    # DO NOT install build tools for C/C++ and others, set it per project by devShell instead
    gnumake # used by this repo, to simplify the deployment
    jdk17   # used to run some java based tools(.jar)
    gradle
    maven
    spring-boot-cli

    # scheme related
    guile

    # python
    (python311.withPackages (ps:
      with ps; [
        ipykernel jupyterlab 
        matplotlib numpy seaborn
        networkx
        beautifulsoup4
        selenium
        urllib3
        pyclip
        pybluez
        pymysql
        jieba
        wordcloud
        pandas-datareader
        pip # use in venv "python -m venv .venv" "source .venv/bin/activate"

        ipython
        pandas
        requests
        pyquery
        pyyaml
      ]))

    # db related
    dbeaver
    mycli
    pgcli
    mongosh
    sqlite

    # embedded development
    minicom

    # other tools
    bfg-repo-cleaner  # remove large files from git history
    k6 # load testing tool
    mitmproxy # http/https proxy tool
    tcpdump
    protobuf # protocol buffer compiler
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
