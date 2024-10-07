{
  pkgs,
  pkgs-stable,
  pkgs-unstable,
  nix-gaming,
  nur-DataEraserC,
  pkgs-unstable-yuzu,
  suyu,
  ...
}: let
  # Mihoyo Game Launcher
  aagl-gtk-on-nix =
    import (builtins.fetchTarball
      "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in {
  home.packages = with pkgs-unstable; [
    pkgs-unstable-yuzu.yuzu # Switch games
    # broken so I disable it
    suyu.packages.${pkgs.system}.suyu # Switch games
    pkgs-stable.ryujinx # Switch games

    steamPackages.steamcmd # steam command line

    hmcl # MineCraft Launcher
    minecraft # Official MineCraft Launcher
    # prismlauncher

    pkgs-stable.mindustry-wayland
    #mindustry-server

    # Mihoyo Game Launcher
    # aagl-gtk-on-nix.anime-game-launcher
    # aagl-gtk-on-nix.anime-borb-launcher
    # aagl-gtk-on-nix.honkers-railway-launcher
    # aagl-gtk-on-nix.honkers-launcher

    # An anime game server
    nur-DataEraserC.packages.${pkgs.system}.grasscutter
    # nix-gaming.packages.${pkgs.system}.osu-stable
    nix-gaming.packages.${pkgs.system}.osu-lazer-bin
  ];
}
