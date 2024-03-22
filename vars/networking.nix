{lib}: rec {
  mainGateway = "192.168.5.1"; # main router
  defaultGateway = "192.168.5.101"; # subrouter with a transparent proxy
  nameservers = [
    "119.29.29.29" # DNSPod
    "223.5.5.5" # AliDNS
  ];
  prefixLength = 24;

  hostsAddr = {
    # Homelab's Physical Machines (KubeVirt Nodes)
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

    # Other VMs and Physical Machines
    ai = {
      # Desktop PC
      iface = "enp5s0";
      ipv4 = "192.168.5.100";
    };
    aquamarine = {
      # VM
      iface = "ens18";
      ipv4 = "192.168.5.101";
    };
    ruby = {
      # VM
      iface = "ens18";
      ipv4 = "192.168.5.102";
    };
    kana = {
      # VM
      iface = "ens18";
      ipv4 = "192.168.5.103";
    };
    nozomi = {
      # LicheePi 4A's wireless iterface - RISC-V
      iface = "wlan0";
      ipv4 = "192.168.5.104";
    };
    yukina = {
      # LicheePi 4A's wireless iterface - RISC-V
      iface = "wlan0";
      ipv4 = "192.168.5.105";
    };
    chiaya = {
      # VM
      iface = "ens18";
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

    k3s-prod-1-master-1 = {
      # VM
      iface = "ens18";
      ipv4 = "192.168.5.108";
    };
    k3s-prod-1-master-2 = {
      # VM
      iface = "ens18";
      ipv4 = "192.168.5.109";
    };
    k3s-prod-1-master-3 = {
      # VM
      iface = "ens18";
      ipv4 = "192.168.5.110";
    };
    k3s-prod-1-worker-1 = {
      # VM
      iface = "ens18";
      ipv4 = "192.168.5.111";
    };
    k3s-prod-1-worker-2 = {
      # VM
      iface = "ens18";
      ipv4 = "192.168.5.112";
    };
    k3s-prod-1-worker-3 = {
      # VM
      iface = "ens18";
      ipv4 = "192.168.5.113";
    };

    k3s-test-1-master-1 = {
      # KubeVirt VM
      iface = "eth1";
      ipv4 = "192.168.5.114";
    };
    k3s-test-1-master-2 = {
      # KubeVirt VM
      iface = "eth1";
      ipv4 = "192.168.5.115";
    };
    k3s-test-1-master-3 = {
      # KubeVirt VM
      iface = "eth1";
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
    # ''
    #   Host ruby
    #     HostName 192.168.5.102
    #     Port 22
    #
    #   Host kana
    #     HostName 192.168.5.103
    #     Port 22
    #   ...
    # '';
    extraConfig =
      lib.attrsets.foldlAttrs
      (acc: host: val:
        acc
        + ''
          Host ${host}
            HostName ${val.ipv4}
            Port 22
        '')
      ""
      hostsAddr;

    # define the host key for remote builders so that nix can verify all the remote builders
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
        hostNames = [host hostsAddr.${host}.ipv4];
        publicKey = value.publicKey;
      })
      {
        aquamarine.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHJrHY3BZRTu0hrlsKxqS+O4GDp4cbumF8aNnbPCGKji root@aquamarine";
        ruby.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOAMmGni8imcaS40cXgLbVQqPYnDYKs8MSbyWL91RV98 root@ruby";
        kana.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIcINkxU3KxPsCpWltfEBjDYtKEeCmgrDxyUadl1iZ1D root@kana";
      };
  };
}
