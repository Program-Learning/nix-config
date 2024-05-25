{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
  ];
  # maybe for mc
  networking.firewall.allowedTCPPortRanges = [
  ];
  networking.firewall.allowedUDPPortRanges = [
  ];
}
