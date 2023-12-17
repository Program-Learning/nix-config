{
  catppuccin-hyprland,
  ...
}: {
  imports = [
    ./anyrun.nix
    ./wayland-apps.nix
    ./hyprland-utils
  ];

  # hyprland configs, based on https://github.com/notwidow/hyprland
  xdg.configFile."hypr" = {
    source = ./hypr-conf;
    recursive = true;
  };

  xdg.configFile."hypr/themes" = {
    source = "${catppuccin-hyprland}/themes";
    recursive = true;
  };

  # music player - mpd
  xdg.configFile."mpd" = {
    source = ./mpd;
    recursive = true;
  };

  # allow fontconfig to discover fonts and configurations installed through home.packages
  fonts.fontconfig.enable = true;

  systemd.user.sessionVariables = {
    "NIXOS_OZONE_WL" = "1"; # for any ozone-based browser & electron apps to run on wayland
    "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
    "MOZ_WEBRENDER" = "1";
    "QT_QPA_PLATFORM" = "wayland";
    "SDL_VIDEODRIVER" = "wayland";
    "GDK_BACKEND" = "wayland";

    # for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/
    "LIBVA_DRIVER_NAME" = "nvidia";
    "XDG_SESSION_TYPE" = "wayland";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "WLR_EGL_NO_MODIFIRES" = "1";
  };
}
