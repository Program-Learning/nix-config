{
  pkgs,
  lib,
  config,
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

    # dconf-editor
    pkgs.dconf-editor
  ];
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      show-battery-percentage = true;
      clock-show-seconds = true;
    };
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
        "autoclose-xwayland" # automatically terminates Xwayland if all relevant X11 clients are gone
      ];
    };
    # 挂起恢复有问题
    settings."org/gnome/settings-daemon/plugins/power" = {
      # 禁用使用电池时的自动挂起
      sleep-inactive-battery-type = "nothing";
      # 禁用插入电源时的自动挂起
      sleep-inactive-ac-type = "nothing";
      # 设置电源按钮行为为nothing
      power-button-action = "nothing";
    };

    # nautilus view using list-view
    settings."org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
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

    # 设置自定义快捷键

    settings."org/gnome/desktop/wm/keybindings" = {
      close = [
        "<Super>q"
        "<Alt>F4"
      ];
    };

    settings."org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
    ];

    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Launch Terminal";
      command = "ghostty";
      binding = "<Super>Return";
    };

    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "PowerOff Monitor";
      command = "dbus-send --session --dest=org.gnome.ScreenSaver --type=method_call /org/gnome/ScreenSaver org.gnome.ScreenSaver.SetActive boolean:true";
      binding = "PowerOff";
    };

    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "PowerOff Monitor";
      command = "dbus-send --session --dest=org.gnome.ScreenSaver --type=method_call /org/gnome/ScreenSaver org.gnome.ScreenSaver.SetActive boolean:true";
      binding = "<Shift><Super>p";
    };

    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "Run Menu";
      command = "anyrun";
      binding = "<Super>d";
    };

    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      name = "Open File Manager";
      command = "nautilus";
      binding = "<Super>e";
    };

    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      name = "Open Mission Center";
      command = "missioncenter";
      binding = "<Ctrl><Shift>Escape";
    };
  };
  # https://github.com/jz8132543/flakes/blob/3225d8f726da9a8980a7becc949f3f634927f926/home-manager/modules/desktop/gnome.nix#L293-L321
  # NOTE: make sure dumpped gsconnect.dconf is persistent if you are using tmpfs as root
  systemd.user.services.gsconnect-dconf = {
    Unit = {
      Description = "gsconnect-dconf";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = toString (
        pkgs.writeScript "gsconnect-dconf-start" ''
          #! ${pkgs.runtimeShell} -el
          ${pkgs.dconf}/bin/dconf load /org/gnome/shell/extensions/gsconnect/ < ${config.home.homeDirectory}/.config/gsconnect/gsconnect.dconf || true
        ''
      );
      ExecStop = toString (
        pkgs.writeScript "gsconnect-dconf-stop" ''
          #! ${pkgs.runtimeShell} -el
          ${pkgs.dconf}/bin/dconf dump /org/gnome/shell/extensions/gsconnect/ > ${config.home.homeDirectory}/.config/gsconnect/gsconnect.dconf
        ''
      );
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
      RemainAfterExit = "yes";
    };
  };
}
