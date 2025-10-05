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
  hostName = "ai"; # Define your hostname.

  macAddress = "random";
  inherit (myvars.networking) mainGateway mainGateway6 nameservers;
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
    ./secureboot.nix
    ./dae.nix
  ];

  services.sunshine.enable = true;

  networking = {
    inherit hostName;
    # hostName = "DESKTOP-GM6XG0X";

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

          get_ip_info(){
            # 获取IPv4地址
            IPV4_ADDR=$(ip -4 addr show dev $INTERFACE 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)

            # 获取IPv6地址（全局范围）
            IPV6_ADDR=$(ip -6 addr show dev $INTERFACE 2>/dev/null | grep -oP '(?<=inet6\s)[0-9a-f:]+' | grep -v '^fe80:' | head -n1)

            # 获取公网IP（如果有网络连接）
            PUBLIC_IP=$(curl -s -4 ifconfig.co 2>/dev/null || curl -s -6 ifconfig.co 2>/dev/null || echo "N/A")

            # 构建IP信息字符串
            IP_INFO=""
            if [ -n "$IPV4_ADDR" ]; then
                IP_INFO="IPv4: $IPV4_ADDR"
            fi
            if [ -n "$IPV6_ADDR" ]; then
                if [ -n "$IP_INFO" ]; then
                    IP_INFO="$IP_INFO, IPv6: $IPV6_ADDR"
                else
                    IP_INFO="IPv6: $IPV6_ADDR"
                fi
            fi
            if [ -n "$PUBLIC_IP" ] && [ "$PUBLIC_IP" != "N/A" ]; then
                IP_INFO="$IP_INFO, Public: $PUBLIC_IP"
            fi

            echo "''${IP_INFO:-No IP addresses found}"
          }

          notify_status(){
            alias_for_work=/etc/agenix/alias-for-work.bash
            if [ -f $alias_for_work ]; then
              . $alias_for_work
            else
              echo "No alias file found for work"
            fi

            # 获取IP信息
            IP_INFO=$(get_ip_info)

            MSG="PC[r9000p2025][nixos] online(Device Interface: $DEVICE_IFACE, Connection: $CONNECTION_ID($CONNECTION_UUID), Status: $STATUS, IP: $IP_INFO, Time: $(date +%Y-%m-%dT%H:%M:%S%Z))"
            notify-send "Network Status" "$MSG"
            ${pkgs.ntfy-sh}/bin/ntfy publish $ntfy_topic "$MSG"
          }

          anonymous(){
            ~/.config/*/scripts/tp_link_script http://192.168.0.1 111111 "$(cat /sys/class/net/wlp0s20f3/address)" "匿名主机" 0
          }

          case "$STATUS" in
            up)
              # 等待一下确保IP地址已经分配
              sleep 2
              notify_status
              anonymous
            ;;
            vpn-up)
              sleep 2
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
  };
  # systemd.network.networks."10-${iface}" = {
  #   matchConfig.Name = [ iface ];
  #   networkConfig = {
  #     Address = [
  #       ipv4WithMask
  #       ipv6WithMask
  #     ];
  #     DNS = nameservers;
  #     DHCP = "ipv6"; # enable DHCPv6 only, so we can get a GUA.
  #     IPv6AcceptRA = true; # for Stateless IPv6 Autoconfiguraton (SLAAC)
  #     LinkLocalAddressing = "ipv6";
  #   };
  #   routes = [
  #     {
  #       Destination = "0.0.0.0/0";
  #       Gateway = mainGateway;
  #     }
  #     {
  #       Destination = "::/0";
  #       Gateway = mainGateway6;
  #       GatewayOnLink = true; # it's a gateway on local link.
  #     }
  #   ];
  # };

  # networking.useNetworkd = true;
  # systemd.network.enable = true;

  # conflict with feature: containerd-snapshotter
  # virtualisation.docker.storageDriver = "btrfs";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  features.bigdata_hadoop = {
    enable = false;
    package = pkgs.hadoop_3_3;
    impermanence.enable = true;
  };
}
