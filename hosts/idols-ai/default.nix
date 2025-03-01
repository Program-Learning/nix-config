{
  config,
  pkgs,
  lib,
  myvars,
  nur-DataEraserC,
  nixGL,
  ...
} @ args:
#############################################################
#
#  Ai - my main computer, with NixOS + i7-11800H + RTX 3060 Mobile / Max-Q GPU, for gaming & daily use.
#
#############################################################
let
  hostName = "ai"; # Define your hostname.
  macAddress = "random";
in rec {
  imports = [
    ./netdev-mount.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix

    ./impermanence.nix
    ./impermanence_addon.nix
    ./secureboot.nix
    ./dae.nix
  ];

  networking = {
    hostName = "LAPTOP-UBERCOA";
    # inherit hostName;
    inherit (myvars.networking) defaultGateway nameservers;
    inherit (myvars.networking.hostsInterface.${hostName}) interfaces;

    # desktop need its cli for status bar
    networkmanager.enable = true;
    networkmanager.wifi.macAddress = macAddress;
    networkmanager.ethernet.macAddress = macAddress;
    networkmanager.dispatcherScripts = [
      {
        source = pkgs.writeText "upHook" ''
          INTERFACE=$1
          STATUS=$2
          notify_online(){
            alias_for_work=/etc/agenix/alias-for-work.bash
            if [ -f $alias_for_work ]; then
              . $alias_for_work
            else
              echo "No alias file found for work"
            fi
            ${pkgs.ntfy-sh}/bin/ntfy publish $ntfy_topic "PC[y9000k2021h][nixos] online(Device Interface: $DEVICE_IFACE, Connection: $CONNECTION_ID($CONNECTION_UUID), Time: $(date +%Y-%m-%dT%H:%M:%S%Z))"
          }
          anonymous(){
            ~/.config/hypr/scripts/tp_link_script http://192.168.0.1 111111 "$(cat /sys/class/net/wlp0s20f3/address)" "匿名主机" 0
          }

          case "$STATUS" in
            up)
              notify_online
              anonymous
            ;;
            vpn-up)
              notify_online
              anonymous
            ;;
            down)
            ;;
            vpn-down)
            ;;
          esac
        '';
        type = "basic";
      }
    ];
    enableIPv6 = true; # disable ipv6
    extraHosts = myvars.networking.genericHosts;
  };

  # conflict with feature: containerd-snapshotter
  # virtualisation.docker.storageDriver = "btrfs";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
