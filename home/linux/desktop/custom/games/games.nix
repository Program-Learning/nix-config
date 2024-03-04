{
  pkgs,
  pkgs-unstable,
  nix-gaming,
  nur-xddxdd,
  ...
}: let
  # Mihoyo Game Launcher
  aagl-gtk-on-nix =
    import (builtins.fetchTarball
      "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in {
  home.packages = with pkgs-unstable; [
    yuzu # Switch games
    ryujinx # Switch games

    steamPackages.steamcmd # steam command line
    
    hmcl # MineCraft Launcher
    minecraft # Official MineCraft Launcher
    # prismlauncher

    mindustry-wayland
    #mindustry-server

    # Mihoyo Game Launcher
    # aagl-gtk-on-nix.anime-game-launcher
    # aagl-gtk-on-nix.anime-borb-launcher
    # aagl-gtk-on-nix.honkers-railway-launcher
    # aagl-gtk-on-nix.honkers-launcher

    # An anime game server
    nur-xddxdd.packages.${pkgs.system}.grasscutter
    nix-gaming.packages.${pkgs.system}.osu-stable
  ];
}
