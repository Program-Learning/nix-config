{
  config,
  lib,
  ...
}:

let
  cfgNiri = config.modules.desktop.niri;
in
lib.mkIf cfgNiri.enable {
  xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;

  # Hyprland idle daemon
  services.hypridle.enable = true;
}
