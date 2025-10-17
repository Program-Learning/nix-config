{
  pkgs,
  lib,
  nur-ryan4yin,
  ...
}:
let
in
{
  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    blur-my-shell
    gsconnect
    kimpanel
    clipboard-indicator
  ];
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        appindicator.extensionUuid
        blur-my-shell.extensionUuid
        gsconnect.extensionUuid
        kimpanel.extensionUuid
        clipboard-indicator.extensionUuid
      ];
    };
    settings."org/gnome/mutter" = {
      experimental-features = [
        "scale-monitor-framebuffer" # Enables fractional scaling (125% 150% 175%)
        "variable-refresh-rate" # Enables Variable Refresh Rate (VRR) on compatible displays
        "xwayland-native-scaling" # Scales Xwayland applications to look crisp on HiDPI screens
      ];
    };

    # 设置 GNOME Remote Desktop RDP 端口为 23389，并允许在占用时向后搜索 10 个端口
    settings."org/gnome/desktop/remote-desktop/rdp" = {
      # port = 23389; # 目前不知道为什么不起效
      # "negotiate-port" = true; # 目前不知道为什么不起效
      enable = true;
    };

    # settings."org/gnome/desktop/remote-desktop/rdp/headless" = {
    #  port = 23390; # 目前不知道为什么不起效
    #  "negotiate-port" = true; # 目前不知道为什么不起效
    #  enable = false;
    # };
  };
}
