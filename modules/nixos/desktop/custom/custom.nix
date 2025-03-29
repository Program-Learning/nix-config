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
}: {
  imports = [
    nur-DataEraserC.nixosModules.cpolar
  ];
  programs.wshowkeys.enable = true;

  programs.proxychains = {
    chain.type = "dynamic";
    enable = true;
    proxies = {
      localhost_clash_proxy = {
        enable = true;
        type = "socks5";
        host = "127.0.0.1";
        port = 7890;
      };
      localhost_nekoray_proxy = {
        enable = true;
        type = "socks5";
        host = "127.0.0.1";
        port = 2080;
      };
      tailscale_mondrian_nekobox_proxy = {
        enable = true;
        type = "socks5";
        host = "100.95.92.151";
        port = 2080;
      };
      zerotier_mondrian_nekobox_proxy = {
        enable = true;
        type = "socks5";
        host = "10.147.20.151";
        port = 2080;
      };
      tailscale_pstar_nekobox_proxy = {
        enable = true;
        type = "socks5";
        host = "100.95.92.153";
        port = 2080;
      };
      zerotier_pstar_nekobox_proxy = {
        enable = true;
        type = "socks5";
        host = "10.147.20.153";
        port = 2080;
      };
    };
  };

  programs.darling = {
    enable = false;
    package = pkgs-stable.darling;
  };

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
    enable = true;
    certificate = "${mysecrets}/public/Cloudflare_CA.pem"; # download here https://developers.cloudflare.com/cloudflare-one/connections/connect-devices/warp/install-cloudflare-cert/
  };

  services.logind = {
    killUserProcesses = true;
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    powerKey = "ignore";
    # rebootKey = "ignore";
    extraConfig = ''
    '';
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

  nixpkgs.config.permittedInsecurePackages = ["openssl-1.1.1v" "electron-19.0.7" "electron-19.1.9"];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "wechat_dev_tools"
      "qq"
    ];
  documentation.dev.enable = true;

  environment.extraOutputsToInstall = ["dev"];

  services.cloudflared = {
    enable = false;
  };

  # recording tool
  features.wf-recorder.enable = true;
  # clash tun mode fix
  programs.clash-verge = {
    enable = true;
    autoStart = false;
    package = pkgs.clash-verge-rev;
  };
  features.mihomo-party = {
    enable = true;
    autoStart = true;
    tunMode = true;
    package = pkgs.mihomo-party;
  };
  features.clash-nyanpasu = {
    enable = false;
    package = pkgs.clash-nyanpasu;
    tunMode = true;
  };
  services.sing-box = {
    enable = true;
    settings = {
      experimental = {
        cache_file = {
          enabled = true;
        };
        clash_api = {
          external_controller = "0.0.0.0:9090";
          external_ui = "@yacd@";
        };
      };
    };
  };
  # useless
  features.nekoray = {
    enable = false;
    package = pkgs.nekoray;
    tunMode = true;
  };
  # firmware update tool
  services.fwupd.enable = true;
}
