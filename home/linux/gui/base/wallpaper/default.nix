{
  pkgs,
  config,
  lib,
  wallpapers,
  ...
}:
let
  mklinkWallpaperPath =
    config: FilePath:
    if config.modules.mkOutOfStoreSymlink.enable then
      (lib.warn "mkOutOfStoreSymlink ${config.modules.mkOutOfStoreSymlink.wallpaperPath}/${FilePath}"
        config.lib.file.mkOutOfStoreSymlink
        "${config.modules.mkOutOfStoreSymlink.wallpaperPath}/${FilePath}"
      )
    else
      (lib.warn "direct use ${wallpapers}" "${wallpapers}");
  wallpapers_dir = mklinkWallpaperPath config "";
in
{
  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Wallpaper Switcher daemon";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = lib.getExe (
        pkgs.writeShellApplication {
          name = "wallpaper";
          runtimeInputs = with pkgs; [
            procps
            feh
            swaybg
            python3
          ];
          text = ''
            export WALLPAPERS_DIR="${wallpapers_dir}"
            export WALLPAPERS_STATE_FILEPATH="${config.xdg.stateHome}/wallpaper-switcher/switcher_state"
            export WALLPAPER_WAIT_MIN=60
            export WALLPAPER_WAIT_MAX=180
            export WALLPAPERS_CLASS="dark"
            exec ${./wallpaper-switcher.py}
          '';
        }
      );
      RestartSec = 3;
      Restart = "on-failure";
    };
  };
}
