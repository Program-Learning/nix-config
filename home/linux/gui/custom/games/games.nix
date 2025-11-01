{
  pkgs,
  pkgs-stable,
  pkgs-latest,
  nix-gaming,
  nur-DataEraserC,
  pkgs-unstable-yuzu,
  suyu,
  ...
}:
let
  # Mihoyo Game Launcher
  aagl-gtk-on-nix = import (
    builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz"
  );
in
{
  home.packages = with pkgs-latest; [
    # Mihoyo Game Launcher
    # aagl-gtk-on-nix.anime-game-launcher
    # aagl-gtk-on-nix.anime-borb-launcher
    # aagl-gtk-on-nix.honkers-railway-launcher
    # aagl-gtk-on-nix.honkers-launcher

    # An anime game server
    # nur-DataEraserC.packages.${pkgs.system}.UnknownAnimeGamePS-wrapper
  ];
}
