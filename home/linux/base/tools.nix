{
  pkgs,
  pkgs-unstable-etcher,
  ...
}: {
  # Linux Only Packages, not available on Darwin
  home.packages = with pkgs; [
    # misc
    libnotify
    wireguard-tools # manage wireguard vpn manually, via wg-quick

    ventoy # create bootable usb
    pkgs-unstable-etcher.etcher # create bootable usb
    virt-viewer # vnc connect to VM, used by kubevirt
  ];

  # auto mount usb drives
  services = {
    udiskie.enable = true;
    # syncthing.enable = true;
  };
}
