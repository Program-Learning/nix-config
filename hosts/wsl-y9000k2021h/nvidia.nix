{
  config,
  pkgs,
  pkgs-unstable,
  nur-DataEraserC,
  nixGL,
  ...
}: {
  # ===============================================================================================
  # for Nvidia GPU
  # ===============================================================================================

  # https://wiki.hyprland.org/Nvidia/
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    # Since NVIDIA does not load kernel mode setting by default,
    # enabling it is required to make Wayland compositors function properly.
    # ONLY SOME LATEST NIXPKGS REQUIRE THIS WORK AROUND
    # "nvidia-drm.fbdev=1"
  ];
  services.xserver.videoDrivers = ["nvidia"]; # will install nvidia-vaapi-driver by default
  hardware.nvidia = {
    open = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = config.boot.kernelPackages.nvidiaPackages.beta;

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
    # nur-DataEraserC.packages.${pkgs.system}.cudatoolkit_dev_env_fhs

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
  # disable cudasupport before this issue get fixed:
  # https://github.com/NixOS/nixpkgs/issues/338315
  nixpkgs.config.cudaSupport = false;

  nixpkgs.overlays = [
    (_: super: {
      blender = super.blender.override {
        # https://nixos.org/manual/nixpkgs/unstable/#opt-cudaSupport
        cudaSupport = true;
        waylandSupport = true;
      };

      # ffmpeg-full = super.ffmpeg-full.override {
      #   withNvcodec = true;
      # };
    })
  ];
}
