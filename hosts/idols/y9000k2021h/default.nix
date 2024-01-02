#############################################################
#
#  Ai - my main computer, with NixOS + I5-13600KF + RTX 4090 GPU, for gaming & daily use.
#
#############################################################
{
  imports = [
    # ./cifs-mount.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # ./impermanence.nix
    # ./secureboot.nix
  ];

  networking = {
    hostName = "y9000k2021h";
    wireless.enable = false; # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    networkmanager.enable = true;

    # enableIPv6 = false; # disable ipv6
    interfaces.wlp0s20f3 = {
      useDHCP = true;
      #ipv4.addresses = [
      #  {
      #    address = "192.168.0.120";
      #    prefixLength = 24;
      #  }
      #];
    };
    #defaultGateway = "192.168.0.1";
    nameservers = [
      "119.29.29.29" # DNSPod
      "223.5.5.5" # AliDNS
    ];
  };

  # conflict with feature: containerd-snapshotter
  # virtualisation.docker.storageDriver = "btrfs";

  # for Nvidia GPU
  services.xserver.videoDrivers = ["nvidia"]; # will install nvidia-vaapi-driver by default
  hardware.nvidia = {
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.stable;

    # required by most wayland compositors!
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    prime = {
    	offload = {
			  enable = false;
			  enableOffloadCmd = false;
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
