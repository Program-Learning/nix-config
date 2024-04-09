{
  pkgs,
  pkgs-stable,
  ...
}: {
  # Linux Only Packages, not available on Darwin
  home.packages = with pkgs; [
    # misc
    libnotify
    wireguard-tools # manage wireguard vpn manually, via wg-quick

    ventoy # create bootable usb
    pkgs-stable.etcher # create bootable usb
    virt-viewer # vnc connect to VM, used by kubevirt
    baobab # Graphical disk usage analyzer
  ];

  # auto mount usb drives
  services = {
    udiskie.enable = true;
    # syncthing.enable = true;
  };
}
