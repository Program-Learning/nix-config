{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
  ];
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };
  };
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 10000;
      to = 10010;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 10000;
      to = 10010;
    }
  ];
}
