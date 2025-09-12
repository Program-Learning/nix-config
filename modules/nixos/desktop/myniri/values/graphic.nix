{
  pkgs,
  lib,
  config,
  ...
}: 
let
  cfgWayland = config.modules.desktop.wayland;
  cfgHyprland = config.modules.desktop.hyprland;
  cfgNiri = config.modules.desktop.myniri;
  cfgGnomeWayland = config.modules.desktop.gnome-wayland;
  cfgKdeWayland = config.modules.desktop.kde-wayland;
in
{
  # NOTE: this niri spec conf from
  # https://github.com/YaLTeR/niri/blob/main/resources/niri-portals.conf
  # https://github.com/YaLTeR/niri/wiki/Important-Software
  xdg.portal = lib.mkIf cfgNiri.enable {
    enable = true;

    config = {
      common = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [
          "gnome-keyring"
        ];
        "org.freedesktop.impl.portal.Notification" = [
          "gtk"
        ];
        "org.freedesktop.impl.portal.Access" = [
          "gtk"
        ];
      };
    };

    # Sets environment variable NIXOS_XDG_OPEN_USE_PORTAL to 1
    # This will make xdg-open use the portal to open programs,
    # which resolves bugs involving programs opening inside FHS envs or with unexpected env vars set from wrappers.
    # xdg-open is used by almost all programs to open a unknown file/uri
    # alacritty as an example, it use xdg-open as default, but you can also custom this behavior
    # and vscode has open like `External Uri Openers`
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk # for gtk
      xdg-desktop-portal-gnome # for gnome
      # xdg-desktop-portal-kde  # for kde
    ];
  };
}
