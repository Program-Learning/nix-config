{
  config,
  lib,
  mylib,
  ...
}:

let
  cfgNiri = config.modules.desktop.niri;
  mkSymlink = mylib.mklinkRelativeToRoot;
in
lib.mkIf cfgNiri.enable {
  xdg.configFile."hypr/hypridle.conf".source =
    mkSymlink config "home/linux/gui/base/hypridle/hypridle.conf";

  # Hyprland idle daemon
  services.hypridle.enable = true;
}
