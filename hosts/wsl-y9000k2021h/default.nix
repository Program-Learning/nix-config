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
  hostName = "wsl-y9000k2021h"; # Define your hostname.
  macAddress = "random";
in rec {
  imports = [
    ./netdev-mount.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./impermanence.nix
    # ./secureboot.nix
  ];

  networking = {
    inherit hostName;
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
            ${pkgs.ntfy-sh}/bin/ntfy publish $ntfy_topic "PC[${hostName}][nixos] online(Device Interface: $DEVICE_IFACE) at $(date +%Y-%m-%dT%H:%M:%S%Z)"
          }
          case "$STATUS" in
            up)
              notify_online
            ;;
            vpn-up)
              notify_online
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

  # for Nvidia GPU
  services.xserver.videoDrivers = ["nvidia" "modesetting"]; # will install nvidia-vaapi-driver by default
  hardware.nvidia = {
    open = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
    # package = config.boot.kernelPackages.nvidiaPackages.stable;

    # required by most wayland compositors!
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Make sure to use the correct Bus ID values for your system!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
  };
  virtualisation.docker.enableNvidia = true; # for nvidia-docker

  hardware.graphics = {
    enable = true;
    # needed by nvidia-docker
    enable32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    # for mount luks disk from nixos
    cryptsetup
    # lenovo-legion
    nur-DataEraserC.packages.${pkgs.system}.cudatoolkit_dev_env

    # too big so disabled
    # nixGL
    # nixGL.packages.${pkgs.system}.nixGL
    # nixGL.packages.${pkgs.system}.nixGLDefault
    # nixGL.packages.${pkgs.system}.nixGLNvidia
    # nixGL.packages.${pkgs.system}.nixGLNvidiaBumblebee
    # nixGL.packages.${pkgs.system}.nixGLIntel
    # nixGL.packages.${pkgs.system}.nixVulkanNvidia
    # nixGL.packages.${pkgs.system}.nixVulkanIntel
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
