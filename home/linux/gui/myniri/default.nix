{
  pkgs,
  config,
  lib,
  ...
}@args:
with lib;
let
  cfg = config.modules.desktop.myniri;
in
{
  imports = [
    ./options
  ];

  options.modules.desktop.myniri = {
    enable = mkEnableOption "niri";
  };

  config = mkIf cfg.enable (mkMerge (import ./values args));
}
