{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; let
  cfg = config.modules.desktop.niri;
in {
  imports = [
    ./options
  ];

  options.modules.desktop.niri = {
    enable = mkEnableOption "niri";
  };

  config = mkIf cfg.enable (
    mkMerge (import ./values args)
  );
}
