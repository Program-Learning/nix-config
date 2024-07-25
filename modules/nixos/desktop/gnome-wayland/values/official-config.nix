{lib, ...}: {
  services.xserver = {
    enable = lib.mkForce true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
