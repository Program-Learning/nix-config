{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./features/sunshine.nix
    ./features/wf-recorder.nix
  ];
  programs = {
    wshowkeys.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };

    proxychains = {
      enable = true;
      proxies = {
        myproxy = {
          enable = true;
          type = "socks5";
          host = "127.0.0.1";
          port = 7890;
        };
      };
    };

    darling = {enable = true;};
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

  services = {
    logind = {
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
      extraConfig = "HandlePowerKey=ignore";
      # powerKey = "ignore";
      # rebootKey = "ignore";
    };

    # tlp = {
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
  };

  systemd.services = {
    cpolar = {
      enable = true;
      # path = "/home/nixos/Apps/Bins/cpolar/";
      description = "cpolar secure tunnels to localhost webhook development tool and debugging tool.";
      unitConfig = {
        # ...
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          /home/nixos/Apps/Bins/cpolar/cpolar "start-all" "-daemon=on" "-dashboard=on" "-log=/home/nixos/Apps/Bins/cpolar/.cpolar/logs/cpolar_service.log" "-config=/home/nixos/Apps/Bins/cpolar/.cpolar/cpolar.yml"'';
        # ...
      };
      wantedBy = ["multi-user.target"];
      # ...
    };
  };

  nixpkgs.config.permittedInsecurePackages = ["openssl-1.1.1v" "electron-19.0.7"];

  environment.extraOutputsToInstall = ["dev"];

  nixpkgs.config.allowUnfreePredicate = ["wechat_dev_tools"];

  documentation.dev.enable = true;

  features.sunshine.enable = true;

  features.wf-recorder.enable = true;
}
