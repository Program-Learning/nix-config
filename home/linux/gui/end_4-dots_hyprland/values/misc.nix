{
  pkgs,
  lib,
  impurity,
  config,
  ...
}: {
  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
    };
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  xdg.userDirs = {
    createDirectories = true;
  };

  gtk = {
    font = {
      name = lib.mkForce "Rubik";
      package = lib.mkForce (pkgs.google-fonts.override {fonts = ["Rubik"];});
      size = lib.mkDefault 11;
    };
    gtk3 = {
      bookmarks = [
        "file://${config.home.homeDirectory}/Downloads"
        "file://${config.home.homeDirectory}/Documents"
        "file://${config.home.homeDirectory}/Pictures"
        "file://${config.home.homeDirectory}/Music"
        "file://${config.home.homeDirectory}/Videos"
        "file://${config.home.homeDirectory}/.config"
        "file://${config.home.homeDirectory}/.config/ags"
        "file://${config.home.homeDirectory}/.config/hypr"
        "file://${config.home.homeDirectory}/GitHub"
        "file:///mnt/Windows"
      ];
    };
  };

  programs = {
    home-manager.enable = true;
  };
  home.stateVersion = "23.11"; # this must be the version at which you have started using the program
}
