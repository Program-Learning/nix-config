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
  networking.firewall.allowedTCPPorts = (lib.range 3389 3398) ++ (lib.range 23389 23398);
}
