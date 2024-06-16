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
    colmena # nixos's remote deployment tool

    # db related
    pkgs-unstable.mycli
    pkgs-unstable.pgcli
    mongosh
    sqlite

    # embedded development
    minicom
    rkdeveloptool
    rkflashtool
    dtc
    screen

    # ai related
    pkgs-unstable.python312Packages.huggingface-hub # huggingface-cli

    # misc
    pkgs-unstable.devbox
    bfg-repo-cleaner # remove large files from git history
    k6 # load testing tool
    protobuf # protocol buffer compiler

    pre-commit
    commitizen # Tool to create committing rules for projects, auto bump versions, and generate changelogs

    # solve coding extercises - learn by doing
    exercism

    # Automatically trims your branches whose tracking remote refs are merged or gone
    # It's really useful when you work on a project for a long time.
    git-trim
    gitleaks

    # need to run `conda-install` before using it
    # need to run `conda-shell` before using command `conda`
    # conda is not available for MacOS
    conda

    # manual
    man-pages
    man-pages-posix

    nur-program-learning.packages.${pkgs.system}.clang_dev_env_fhs
    comma
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
