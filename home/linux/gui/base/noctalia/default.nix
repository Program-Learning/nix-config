{
  lib,
  config,
  mylib,
  pkgs,
  wallpapers,
  noctalia-shell,
  ...
}:

let
  cfgNiri = config.modules.desktop.niri;
  package = noctalia-shell.packages.${pkgs.system}.default;
  mklinkWallpaperPath =
    config: FilePath:
    if config.modules.mkOutOfStoreSymlink.enable then
      (lib.warn "mkOutOfStoreSymlink ${config.modules.mkOutOfStoreSymlink.wallpaperPath}/${FilePath}"
        config.lib.file.mkOutOfStoreSymlink
        "${config.modules.mkOutOfStoreSymlink.wallpaperPath}/${FilePath}"
      )
    else
      (lib.warn "direct use ${wallpapers}" "${wallpapers}");
  wallpapers_dir = mklinkWallpaperPath config "dark";
in
lib.mkIf cfgNiri.enable {
  # Qt for noctalia-shell (replaces former systemd user service Environment=)
  home.sessionVariables = {
    # Qt6: wayland primary, xcb fallback (QT_QPA_PLATFORM).
    "QT_QPA_PLATFORM" = "wayland;xcb";
    "QT_QPA_PLATFORMTHEME" = "qt6ct";
    "QT_AUTO_SCREEN_SCALE_FACTOR" = "1";
  };

  home.packages = [
    package
    pkgs.qt6Packages.qt6ct # for icon theme
    pkgs.app2unit # Launch Desktop Entries (or arbitrary commands) as Systemd user units
  ]
  ++ (lib.optionals pkgs.stdenv.isx86_64 [
    pkgs.gpu-screen-recorder # recoding screen
  ]);

  home.file."Pictures/Wallpapers".source = wallpapers_dir;

  xdg.configFile =
    let
      mkSymlink = mylib.mklinkRelativeToRoot;
      confPath = "home/linux/gui/base/noctalia";
    in
    {
      # NOTE: use config dir as noctalia config because config is not only settings.json
      # https://github.com/noctalia-dev/noctalia-shell/blob/main/nix/home-module.nix#L211-L220
      "noctalia".source = mkSymlink config "${confPath}/config";
      "qt6ct/qt6ct.conf".source = mkSymlink config "${confPath}/qt6ct.conf";
    };
}
