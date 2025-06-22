{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; let
  cfg = config.modules.desktop.hyprland;
in {
  imports = [
    ./options
  ];

  options.modules.desktop.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable (
    mkMerge (import ./values args)
  );
}
