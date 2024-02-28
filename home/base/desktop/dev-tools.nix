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

  home.packages = with pkgs;
    [
      colmena # nixos's remote deployment tool

      # db related
      dbeaver
      mycli
      pgcli
      mongosh
      sqlite

      # embedded development
      rkdeveloptool
      rkflashtool
      minicom
      dtc
      screen
      baobab # Graphical disk usage analyzer

      # ai related
      python311Packages.huggingface-hub # huggingface-cli

      # misc
      pkgs-unstable.devbox
      pre-commit
      bfg-repo-cleaner # remove large files from git history
      k6 # load testing tool
      protobuf # protocol buffer compiler
      nix-init # generate nix package from url

      # solve coding extercises - learn by doing
      exercism
    ]
    ++ (
      if pkgs.stdenv.isLinux
      then [
        # Automatically trims your branches whose tracking remote refs are merged or gone
        # It's really useful when you work on a project for a long time.
        git-trim

        # need to run `conda-install` before using it
        # need to run `conda-shell` before using command `conda`
        # conda is not available for MacOS
        conda

        mitmproxy # http/https proxy tool
        insomnia # REST client
        # hoppscotch is not in nixpkgs now
        # hoppscotch # Api Test Tool
        wireshark # network analyzer

        # manual
        man-pages
        man-pages-posix

        # nur-program-learning.packages.${pkgs.system}.wechat_dev_tools_appimage
        nur-program-learning.packages.${pkgs.system}.clang_dev_env_fhs
        nur-program-learning.packages.${pkgs.system}.wechat_dev_tools_bin
        ventoy # create bootable usb
        etcher
      ]
      else []
    );

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
