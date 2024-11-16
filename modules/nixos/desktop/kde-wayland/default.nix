{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; let
  cfg = config.modules.desktop.kde-wayland;
in {
  imports = [
    ./options
  ];

  options.modules.desktop.kde-wayland = {
    enable = mkEnableOption "kde wayland window manager";
  };

  config = mkIf cfg.enable (
    mkMerge (import ./values args)
  );
}
