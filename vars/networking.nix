{lib}: rec {
  mainGateway = "192.168.0.1"; # main router
  mainGateway6 = "fe80::5"; # main router's link-local address
  # use suzi as the default gateway
  # it's a subrouter with a transparent proxy
  defaultGateway = "192.168.0.1";
  defaultGateway6 = "fe80::8";
  nameservers = [
    # IPv4
    "119.29.29.29" # DNSPod
    "223.5.5.5" # AliDNS
    # IPv6
    "2400:3200::1" # Alidns
    "2606:4700:4700::1111" # Cloudflare
  ];
  prefixLength = 24;

  hostsAddr = rec {
    # ============================================
    # Homelab's Physical Machines (KubeVirt Nodes)
    # ============================================
    kubevirt-shoryu = {
      iface = "eno1";
      ipv4 = "192.168.5.181";
    };
    kubevirt-shushou = {
      iface = "eno1";
      ipv4 = "192.168.5.182";
    };
    kubevirt-youko = {
      iface = "eno1";
      ipv4 = "192.168.5.183";
    };

    # ============================================
    # Other VMs and Physical Machines
    # ============================================
    # ai = {
    #   # Desktop PC
    #   iface = "enp5s0";
    #   ipv4 = "192.168.5.100";
    #   ipv6 = "fe80::10"; # Link-local Address
    # };
    y9000k2021h_1_home = {
      # Laptop
      iface = "wlp0s20f3";
      ipv4 = "192.168.2.150";
      ipv6 = "fe80::150"; # Link-local Address
    };
    y9000k2021h_1_school = {
      # Laptop
      iface = "wlp0s20f3";
      ipv4 = "192.168.0.150";
      ipv6 = "fe80::150"; # Link-local Address
    };
    y9000k2021h_1_zerotier = {
      # Laptop
      iface = "zt5u4z6wb4";
      ipv4 = "10.147.20.150";
      ipv6 = "fe80::150"; # Link-local Address
    };
    y9000k2021h_1_tailscale = {
      # Laptop
      iface = "tailscale0";
      ipv4 = "100.95.92.150";
      ipv6 = "fe80::150"; # Link-local Address
    };
    y9000k2021h = y9000k2021h_1_school;
    r9000p2025 = y9000k2021h;
    ai = r9000p2025;
    wsl-y9000k2021h = y9000k2021h;
    wsl-r9000p2025 = r9000p2025;
    aquamarine = {
      # VM
      iface = "enp2s0";
      ipv4 = "192.168.5.101";
    };
    ruby = {
      # VM
      iface = "enp2s0";
      ipv4 = "192.168.5.102";
    };
    kana = {
      # VM
      iface = "enp2s0";
      ipv4 = "192.168.5.103";
    };
    nozomi = {
      # LicheePi 4A's wireless interface - RISC-V
      iface = "wlan0";
      ipv4 = "192.168.5.104";
    };
    yukina = {
      # LicheePi 4A's wireless interface - RISC-V
      iface = "wlan0";
      ipv4 = "192.168.5.105";
    };
    chiaya = {
      # VM
      iface = "enp2s0";
      ipv4 = "192.168.5.106";
    };
    suzu = {
      # Orange Pi 5 - ARM
      iface = "end1";
      ipv4 = "192.168.5.107";
    };
    rakushun = {
      # Orange Pi 5 - ARM
      # RJ45 port 1 - enP4p65s0
      # RJ45 port 2 - enP3p49s0
      iface = "enP4p65s0";
      ipv4 = "192.168.5.179";
    };
    suzi = {
      iface = "enp2s0"; # fake iface, it's not used by the host
      ipv4 = "192.168.5.178";
      ipv6 = "fe80::8"; # Link-local Address, can be used as default gateway
    };
    mitsuha = {
      iface = "enp2s0"; # fake iface, it's not used by the host
      ipv4 = "192.168.5.177";
    };

    # ============================================
    # Kubernetes Clusters
    # ============================================
    k3s-prod-1-master-1 = {
      # VM
      iface = "enp2s0";
      ipv4 = "192.168.5.108";
    };
    k3s-prod-1-master-2 = {
      # VM
      iface = "enp2s0";
      ipv4 = "192.168.5.109";
    };
    k3s-prod-1-master-3 = {
      # VM
      iface = "enp2s0";
      ipv4 = "192.168.5.110";
    };
    k3s-prod-1-worker-1 = {
      # VM
      iface = "enp2s0";
      ipv4 = "192.168.5.111";
    };
    k3s-prod-1-worker-2 = {
      # VM
      iface = "enp2s0";
      ipv4 = "192.168.5.112";
    };
    k3s-prod-1-worker-3 = {
      # VM
      iface = "enp2s0";
      ipv4 = "192.168.5.113";
    };

    k3s-test-1-master-1 = {
      # KubeVirt VM
      iface = "enp2s0";
      ipv4 = "192.168.5.114";
    };
    k3s-test-1-master-2 = {
      # KubeVirt VM
      iface = "enp2s0";
      ipv4 = "192.168.5.115";
    };
    k3s-test-1-master-3 = {
      # KubeVirt VM
      iface = "enp2s0";
      ipv4 = "192.168.5.116";
    };
  };

  hostsInterface =
    lib.attrsets.mapAttrs
    (
      key: val: {
        interfaces."${val.iface}" = {
          useDHCP = false;
          ipv4.addresses = [
            {
              inherit prefixLength;
              address = val.ipv4;
            }
          ];
        };
      }
    )
    hostsAddr;

  ssh = {
    # define the host alias for remote builders
    # this config will be written to /etc/ssh/ssh_config
    #
    # Config format:
    #   Host —  given the pattern used to match against the host name given on the command line.
    #   HostName — specify nickname or abbreviation for host
    #   IdentityFile — the location of your SSH key authentication file for the account.
    # Format in details:
    #   https://www.ssh.com/academy/ssh/config
    extraConfig =
      ''
        Host gtr5
          HostName 192.168.5.172
          Port 22

        Host um560
          HostName 192.168.5.173
          Port 22

        Host s500plus
          HostName 192.168.5.174
          Port 22
      ''
      + (lib.attrsets.foldlAttrs
        (acc: host: val:
          acc
          + ''
            Host ${host}
              HostName ${val.ipv4}
              Port 22
          '')
        ""
        hostsAddr);

    # this config will be written to /etc/ssh/ssh_known_hosts
    knownHosts =
      # Update only the values of the given attribute set.
      #
      #   mapAttrs
      #   (name: value: ("bar-" + value))
      #   { x = "a"; y = "b"; }
      #     => { x = "bar-a"; y = "bar-b"; }
      lib.attrsets.mapAttrs
      (host: value: {
        hostNames = [host] ++ (lib.optional (hostsAddr ? host) hostsAddr.${host}.ipv4);
        publicKey = value.publicKey;
      })
      {
        # Define the root user's host key for remote builders, so that nix can verify all the remote builders

        aquamarine.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEOXFhFu9Duzp6ZBE288gDZ6VLrNaeWL4kDrFUh9Neic root@aquamarine";
        # ruby.publicKey = "";
        # kana.publicKey = "";

        # ==================================== Other SSH Service's Public Key =======================================

        # https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
        "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
  };
  genericHosts = ''
    155.248.179.129 oracle_ubuntu_1
    192.168.2.151 mondrian_android_home
    10.147.20.151 mondrian_android_cli_zerotier
    10.147.20.151 mondrian_android_app_zerotier
    100.95.92.151 mondrian_android_cli_tailscale
    0.0.0.0 mondrian_android_app_tailscale
    192.168.2.153 pstar_android_home
    10.147.20.153 pstar_android_cli_zerotier
    0.0.0.0 pstar_android_app_zerotier
    100.95.92.153 pstar_android_cli_tailscale
    0.0.0.0 pstar_android_app_tailscale
    192.168.2.150 y9000k2021h_1_home
    10.147.20.150 y9000k2021h_1_zerotier
    100.95.92.150 y9000k2021h_1_tailscale
  '';
}
