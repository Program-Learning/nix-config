{
  pkgs,
  lib,
  nur-ryan4yin,
  ...
}:
let
in
{
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        appindicator.extensionUuid
        blur-my-shell.extensionUuid
        gsconnect.extensionUuid
      ];
    };
    settings."org/gnome/mutter" = {
      experimental-features = [
        "scale-monitor-framebuffer" # Enables fractional scaling (125% 150% 175%)
        "variable-refresh-rate" # Enables Variable Refresh Rate (VRR) on compatible displays
        "xwayland-native-scaling" # Scales Xwayland applications to look crisp on HiDPI screens
      ];
    };
  };
}
