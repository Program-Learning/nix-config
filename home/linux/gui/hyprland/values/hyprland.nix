{
  pkgs,
  pkgs-latest,
  lib,
  hyprland,
  hyprland-plugins,
  hyprland-easymotion,
  hyprfocus,
  Hyprspace,
  hycov,
  nur-ryan4yin,
  ...
}: let
  package = pkgs.hyprland;
  # package = pkgs-latest.hyprland;
  # package = hyprland.packages.${pkgs.system}.hyprland;
in {
  # NOTE:
  # We have to enable hyprland/i3's systemd user service in home-manager,
  # so that gammastep/wallpaper-switcher's user service can be start correctly!
  # they are all depending on hyprland/i3's user graphical-session
  wayland.windowManager.hyprland = {
    inherit package;
    enable = true;
    settings = {
      source = "${nur-ryan4yin.packages.${pkgs.system}.catppuccin-hyprland}/themes/mocha.conf";
      env = [
        "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
        "MOZ_WEBRENDER,1"
        # misc
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland"
        "GDK_BACKEND,wayland,x11"
      ];
    };
    extraConfig = builtins.readFile ../conf/hyprland.conf;
    plugins = [
      # hyprland-plugins.packages.${pkgs.system}.hyprbars # windows bar
      # hyprland-plugins.packages.${pkgs.system}.hyprexpo
      # hyprland-easymotion.packages.${pkgs.system}.hypreasymotion # label windows
      # hyprfocus.packages.${pkgs.system}.hyprfocus # focus anime
      # Hyprspace.packages.${pkgs.system}.Hyprspace # hyprexpo
      # hycov.packages.${pkgs.system}.hycov # a new tiling WM workflow with overview.

      # ...
    ];
    # gammastep/wallpaper-switcher need this to be enabled.
    systemd = {
      enable = true;
      variables = ["--all"];
    };
  };

  # NOTE: this executable is used by greetd to start a wayland session when system boot up
  # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config in NixOS module
  home.file.".wayland-session" = {
    source = "${package}/bin/Hyprland";
    executable = true;
  };

  # hyprland configs, based on https://github.com/notwidow/hyprland
  xdg.configFile = {
    "hypr/mako" = {
      source = ../conf/mako;
      recursive = true;
    };
    "hypr/scripts" = {
      source = ../conf/scripts;
      recursive = true;
    };
    "hypr/waybar" = {
      source = ../conf/waybar;
      recursive = true;
    };
    "hypr/wlogout" = {
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
