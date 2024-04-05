{
  config,
  pkgs,
  lib,
  myvars,
  ...
} @ args:
#############################################################
#
# y9000k2021h - my main computer, with NixOS + i7-11800H + RTX 3060 Mobile / Max-Q GPU, for gaming & daily use.
#
#############################################################
let
  hostName = "y9000k2021h"; # Define your hostname.
  TempMacAddress = "be:fc:85:71:a5:c1";
in rec {
  imports = [
    # ./cifs-mount.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # ./impermanence.nix
    # ./secureboot.nix
  ];

  networking = {
    inherit hostName;
    inherit (myvars.networking) defaultGateway nameservers;
    inherit (myvars.networking.hostsInterface.${hostName}) interfaces;
    networkmanager.enable = true;
    networkmanager.wifi.macAddress = TempMacAddress;
    networkmanager.ethernet.macAddress = TempMacAddress;
    enableIPv6 = true; # disable ipv6
    extraHosts = ''
      155.248.179.129 oracle_ubuntu_1
      192.168.0.121 mondrian_1_school
      192.168.2.121 mondrian_1_home
      10.147.20.121 mondrian_1_cli_zerotier
      10.147.20.107 mondrian_1_app_zerotier
      100.110.6.16 mondrian_1_cli_tailscale
      100.72.65.125 mondrian_1_app_tailscale
      192.168.0.123 pstar_1_school
      192.168.2.123 pstar_1_home
      192.168.0.120 y9000k2021h_1_school
      192.168.2.120 y9000k2021h_1_home
      10.147.20.120 y9000k2021h_1_zerotier
      100.95.7.36 y9000k2021h_1_tailscale
    '';
  };

  # conflict with feature: containerd-snapshotter
  # virtualisation.docker.storageDriver = "btrfs";

  # for Nvidia GPU
  services.xserver.videoDrivers = ["nvidia" "modesetting"]; # will install nvidia-vaapi-driver by default
  hardware.nvidia = {
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
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

  hardware.opengl = {
    enable = true;
    # if hardware.opengl.driSupport is enabled, mesa is installed and provides Vulkan for supported hardware.
    driSupport = true;
    # needed by nvidia-docker
    driSupport32Bit = true;
  };
  environment.systemPackages = with pkgs; [lenovo-legion];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
