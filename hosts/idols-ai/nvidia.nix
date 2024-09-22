{
  pkgs,
  pkgs-unstable,
  nur-DataEraserC,
  nixGL,
  ...
}: {
  # ===============================================================================================
  # for Nvidia GPU
  # ===============================================================================================

  boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
  services.xserver.videoDrivers = ["nvidia" "modesetting"]; # will install nvidia-vaapi-driver by default
  hardware.nvidia = {
    open = false;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
    # package = config.boot.kernelPackages.nvidiaPackages.stable;

    # required by most wayland compositors!
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # # Fine-grained power management. Turns off GPU when not in use.
    # # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # powerManagement.finegrained = true;
    # prime = {
    #   offload = {
    #     enable = true;
    #     enableOffloadCmd = true;
    #   };
    #   # Make sure to use the correct Bus ID values for your system!
    #   intelBusId = "PCI:0:2:0";
    #   nvidiaBusId = "PCI:1:0:0";
    # };
    # # Enable the Nvidia settings menu,
    # # accessible via `nvidia-settings`.
    # nvidiaSettings = true;
  };
  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics = {
    enable = true;
    # needed by nvidia-docker
    enable32Bit = true;
  };
  environment.systemPackages = [
    nur-DataEraserC.packages.${pkgs.system}.cudatoolkit_dev_env
    # nixGL
    # nixGL.packages.${pkgs.system}.nixGL
    nixGL.packages.${pkgs.system}.nixGLDefault
    # nixGL.packages.${pkgs.system}.nixGLNvidia
    # nixGL.packages.${pkgs.system}.nixGLNvidiaBumblebee
    nixGL.packages.${pkgs.system}.nixGLIntel
    # nixGL.packages.${pkgs.system}.nixVulkanNvidia
    nixGL.packages.${pkgs.system}.nixVulkanIntel
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