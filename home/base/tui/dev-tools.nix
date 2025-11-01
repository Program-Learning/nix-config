{
  pkgs,
  pkgs-stable,
  nur-DataEraserC,
  ...
}:
{
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

    tokei # count lines of code, alternative to cloc

    # db related
    mycli
    pgcli
    mongosh
    sqlite

    # embedded development
    minicom
    rkdeveloptool
    rkflashtool
    dtc
    screen

    # ai related
    python313Packages.huggingface-hub # huggingface-cli

    # misc
    devbox
    bfg-repo-cleaner # remove large files from git history
    k6 # load testing tool

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

    # pin clang but do not add to env
    nur-DataEraserC.packages.${pkgs.system}.clang_dev_env_fhs

    # tool for quick package using
    comma
    nix-index

    # git related
    pre-commit
    pkgs-stable.commitizen # Tool to create committing rules for projects, auto bump versions, and generate changelogs
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
