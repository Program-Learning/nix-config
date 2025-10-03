{
  config,
  pkgs,
  lib,
  myvars,
  nur-DataEraserC,
  nixGL,
  ...
}@args:
#############################################################
#
#  Ai - my main computer, with NixOS + AMD Ryzen 9 8945HX + RTX 5070 Laptop GPU, for gaming & daily use.
#
#############################################################
let
  hostName = "r9000p2025"; # Define your hostname.
  macAddress = "random";
  inherit (myvars.networking) defaultGateway defaultGateway6 nameservers;
  inherit (myvars.networking.hostsAddr.${hostName}) iface ipv4 ipv6;
  ipv4WithMask = "${ipv4}/24";
  ipv6WithMask = "${ipv6}/64";
in
rec {
  imports = [
    ./netdev-mount.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix
    ./ai

    ./preservation.nix
    ./impermanence_addon.nix
    # ./secureboot.nix
    # ./dae.nix

    # wsl related
  ];

  networking = {
    inherit hostName;

    # we use networkd instead
    # networkmanager.enable = false; # provides nmcli/nmtui for wifi adjustment
    # useDHCP = false;

    # desktop need its cli for status bar
    networkmanager.enable = true;
    networkmanager.wifi.macAddress = macAddress;
    networkmanager.ethernet.macAddress = macAddress;
    networkmanager.dispatcherScripts = [
      {
        source = pkgs.writeText "upHook" ''
          INTERFACE=$1
          STATUS=$2
          notify_status(){
            alias_for_work=/etc/agenix/alias-for-work.bash
            if [ -f $alias_for_work ]; then
              . $alias_for_work
            else
              echo "No alias file found for work"
            fi
            MSG="PC[r9000p2025][nixos] online(Device Interface: $DEVICE_IFACE, Connection: $CONNECTION_ID($CONNECTION_UUID), Status: $STATUS, Time: $(date +%Y-%m-%dT%H:%M:%S%Z))"
            notify-send $MSG
            ${pkgs.ntfy-sh}/bin/ntfy publish $ntfy_topic $MSG
          }
          anonymous(){
            ~/.config/*/scripts/tp_link_script http://192.168.0.1 111111 "$(cat /sys/class/net/wlp0s20f3/address)" "匿名主机" 0
          }

          case "$STATUS" in
            up)
              notify_status
              anonymous
            ;;
            vpn-up)
              notify_status
              anonymous
            ;;
            down)
              notify_status
            ;;
            vpn-down)
              notify_status
            ;;
          esac
        '';
        type = "basic";
      }
    ];
    enableIPv6 = true; # disable ipv6
    extraHosts = myvars.networking.genericHosts;
  };

  # networking.useNetworkd = true;
  # systemd.network.enable = true;

  # systemd.network.networks."10-${iface}" = {
  #   matchConfig.Name = [iface];
  #   networkConfig = {
  #     Address = [ipv4WithMask ipv6WithMask];
  #     DNS = nameservers;
  #     DHCP = "ipv6"; # enable DHCPv6 only, so we can get a GUA.
  #     IPv6AcceptRA = true; # for Stateless IPv6 Autoconfiguraton (SLAAC)
  #     LinkLocalAddressing = "ipv6";
  #   };
  #   routes = [
  #     {
  #       Destination = "0.0.0.0/0";
  #       Gateway = defaultGateway;
  #     }
  #     {
  #       Destination = "::/0";
  #       Gateway = defaultGateway6;
  #       GatewayOnLink = true; # it's a gateway on local link.
  #     }
  #   ];
  #   linkConfig.RequiredForOnline = "routable";
  # };

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
