{
  config,
  pkgs,
  pkgs-unstable,
  nur-ryan4yin,
  nur-program-learning,
  nur-linyinfeng,
  nur-xddxdd,
  nur-AtaraxiaSjel,
  nur-arti5an,
  nix-gaming,
  aagl,
  nixpkgs-23_05,
  ...
}: let
in {
  home.packages = [
    pkgs-unstable.hyprshot
  ];
}
