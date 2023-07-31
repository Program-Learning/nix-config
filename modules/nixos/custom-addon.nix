{ pkgs, ... }: {

  programs = {
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
  };
  
  systemd.services.cpolar = {
    enable = true;
    # path = "/home/nixos/Apps/Bins/cpolar/";
    description =
      "cpolar secure tunnels to localhost webhook development tool and debugging tool.";
    unitConfig = {
      Type = "simple";
      # ...
    };
    serviceConfig = {
      ExecStart = ''
        /home/nixos/Apps/Bins/cpolar/cpolar "start-all" "-daemon=on" "-dashboard=on" "-log=/home/nixos/Apps/Bins/cpolar/.cpolar/logs/cpolar_service.log" "-config=/home/nixos/Apps/Bins/cpolar/.cpolar/cpolar.yml"'';
      # ...
    };
    wantedBy = [ "multi-user.target" ];
    # ...
  };
  services.logind = {
    lidSwitchDocked = "ignore";
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    extraConfig = "HandlePowerKey=ignore";
  };
}
