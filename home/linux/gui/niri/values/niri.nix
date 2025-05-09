{
  mylib,
  config,
  pkgs,
  pkgs-latest,
  lib,
  nur-ryan4yin,
  ...
}: let
  package = pkgs.niri;
in {
  # NOTE: this executable is used by greetd to start a wayland session when system boot up
  # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config in NixOS module
  home.file.".wayland-session" = {
    source = "${package}/bin/niri-session";
    executable = true;
  };

  xdg.configFile = {
    "niri/config.kdl" = {
      source = mylib.mklink config "home/linux/gui/niri/conf/config.kdl";
    };
    "niri/mako" = {
      source = ../conf/mako;
      recursive = true;
    };
    "niri/scripts" = {
      source = mylib.mklink config "home/linux/gui/niri/conf/scripts";
      recursive = true;
    };
    "niri/waybar" = {
      source = ../conf/waybar;
      recursive = true;
    };
    "niri/wlogout" = {
      source = ../conf/wlogout;
      recursive = true;
    };

    # music player - mpd
    "mpd" = {
      source = ../conf/mpd;
      recursive = true;
    };
  };
}
