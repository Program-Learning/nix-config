{
  lib,
  config,
  pkgs,
  ...
}:
{
  networking.openconnect.interfaces = {
    # e-plant-vpn = {
    #   gateway = "gateway.example.com";
    #   passwordFile = "/var/lib/secrets/openconnect-passwd";
    #   protocol = "anyconnect";
    #   user = "example-user";
    # };
  };

  environment.systemPackages = with pkgs; [
    openconnect
    networkmanager-openconnect
  ];
}
