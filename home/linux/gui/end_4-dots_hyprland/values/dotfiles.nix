{
  pkgs,
  lib,
  end_4-dots_hyprland,
  impurity,
  ...
}: let
  mkRootPath = f: /. + "${f}";
  mkXdgConfigFile = RootPath: f: {
    "${f}" = {
      source = "${RootPath}/${f}";
      recursive = true;
    };
  };
in {
  programs.anyrun.enable = lib.mkForce false;
  programs.fish.enable = lib.mkForce false;
  programs.mpv.enable = lib.mkForce false;
  # hyprland configs, based on https://github.com/notwidow/hyprland
  xdg.configFile = lib.mkMerge (map (mkXdgConfigFile "${end_4-dots_hyprland}") [
    "ags"
    "anyrun"
    "fish"
    "footconfig"
    "foot"
    "fuzzel"
    # "hypr"
    "mpv"
    "qt5ct"
    "wlogout"
    "zshrc.d"
  ]);
}
