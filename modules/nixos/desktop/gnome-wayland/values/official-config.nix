{ lib, ... }:
{
  services.xserver = {
    enable = lib.mkForce true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.gnome.gnome-remote-desktop.enable = true;
  systemd.services.gnome-remote-desktop = {
    wantedBy = [ "graphical.target" ]; # for starting the unit automatically at boot
  };
  networking.firewall.allowedTCPPorts = [ 3389 ];

}
