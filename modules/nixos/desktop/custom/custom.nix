{
  mysecrets,
  config,
  pkgs,
  pkgs-stable,
  pkgs-latest,
  nur-DataEraserC,
  clash-nyanpasu,
  lib,
  ...
}:
{
  programs.wshowkeys.enable = true;

  programs.proxychains = {
    chain.type = "dynamic";
    enable = true;
    proxies = {
      # local
      localhost_clash_proxy = {
        enable = true;
        type = "socks5";
        host = "127.0.0.1";
        port = 7890;
      };
      localhost_throne_proxy = {
        enable = true;
        type = "socks5";
        host = "127.0.0.1";
        port = 2080;
      };
      # mondrian
      mondrian_tailscale_nekobox_proxy = {
        enable = true;
        type = "socks5";
        host = "100.95.92.151";
        port = 2080;
      };
      mondrian_zerotier_nekobox_proxy = {
        enable = true;
        type = "socks5";
        host = "10.147.20.151";
        port = 2080;
      };
      # pstar
      pstar_tailscale_nekobox_proxy = {
        enable = true;
        type = "socks5";
        host = "100.95.92.153";
        port = 2080;
      };
      pstar_zerotier_nekobox_proxy = {
        enable = true;
        type = "socks5";
        host = "10.147.20.153";
        port = 2080;
      };
      # infiniti
      infiniti_tailscale_nekobox_proxy = {
        enable = true;
        type = "socks5";
        host = "100.95.92.154";
        port = 2080;
      };
      infiniti_zerotier_nekobox_proxy = {
        enable = true;
        type = "socks5";
        host = "10.147.20.154";
        port = 2080;
      };
      # y9000p2025
      y9000p2025_tailscale_clash_proxy = {
        enable = true;
        type = "socks5";
        host = "100.95.92.150";
        port = 7897;
      };
      y9000p2025_zerotier_clash_proxy = {
        enable = true;
        type = "socks5";
        host = "10.147.20.150";
        port = 7897;
      };
    };
  };

  # NOTE: this is dropped bcs vendoring python2
  # programs.darling = {
  #   enable = false;
  #   package = pkgs-stable.darling;
  # };

  # environment.variables = {
  #   QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  #   QT_QPA_PLATFORM = "wayland";
  #   QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  #   SDL_VIDEODRIVER = "wayland";
  #   _JAVA_AWT_WM_NONEREPARENTING = "1";
  #   GDK_BACKEND = "wayland";
  #   MOZ_ENABLE_WAYLAND = "1";
  #   QT_SCALE_FACTOR = "1";
  # };
  features.cloudflare-warp = {
    enable = false;
    certificate = "${mysecrets}/public/Cloudflare_CA.pem"; # download here https://developers.cloudflare.com/cloudflare-one/connections/connect-devices/warp/install-cloudflare-cert/
  };

  services.logind = {
    settings = {
      Login = {
        KillUserProcesses = true;
        HandleLidSwitch = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        HandlePowerKey = "ignore";
      };
    };
  };

  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #     CPU_SCALING_GOVERNOR_ON_AC = "powersave";

  #     # The following prevents the battery from charging fully to
  #     # preserve lifetime. Run `tlp fullcharge` to temporarily force
  #     # full charge.
  #     # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
  #     START_CHARGE_THRESH_BAT0 = 40;
  #     STOP_CHARGE_THRESH_BAT0 = 50;

  #     # 100 being the maximum, limit the speed of my CPU to reduce
  #     # heat and increase battery usage:
  #     CPU_MAX_PERF_ON_AC = 75;
  #     CPU_MAX_PERF_ON_BAT = 60;
  #   };
  # };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1v"
    "electron-19.1.9"
    "alist-3.45.0"
    "ventoy-1.1.05"
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "wechat_dev_tools"
      "qq"
    ];
  documentation.dev.enable = true;

  environment.extraOutputsToInstall = [ "dev" ];

  services.cloudflared = {
    enable = false;
  };

  # recording tool
  features.wf-recorder.enable = true;

  # firmware update tool
  services.fwupd.enable = true;
}
