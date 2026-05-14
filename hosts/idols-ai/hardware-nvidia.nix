{
  config,
  lib,
  pkgs,
  nur-DataEraserC,
  nixGL,
  ...
}:
{
  # ===============================================================================================
  # for Nvidia GPU
  # https://wiki.nixos.org/wiki/NVIDIA
  # https://wiki.hyprland.org/Nvidia/
  # ===============================================================================================

  # Hybrid graphics with PRIME[integrated GPU (iGPU) + dedicated GPU (dGPU)]
  hardware.nvidia.prime = {
    # puts dGPU(Nvidia) to sleep and lets the iGPU handle all tasks by default.
    offload = {
      enable = true;
      enableOffloadCmd = true; # generate a nvidia-offload command
    };

    # intelBusId = "PCI:0@0:2:0";
    # nvidiaBusId = "PCI:2@0:0:0";

    # Make sure to use the correct Bus ID values for your system!
    amdgpuBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  boot.kernelParams = [
    # Since NVIDIA does not load kernel mode setting by default,
    # enabling it is required to make Wayland compositors function properly.
    "nvidia-drm.fbdev=1"
  ];
  services.xserver.videoDrivers = [ "nvidia" ]; # will install nvidia-vaapi-driver by default

  hardware.nvidia = {
    # Open-source kernel modules are preferred over and planned to steadily replace proprietary modules
    open = true;
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = config.boot.kernelPackages.nvidiaPackages.production;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;

    # https://github.com/NixOS/nixpkgs/issues/489947
    # package = config.boot.kernelPackages.nvidiaPackages.latest;

    # required by most wayland compositors!
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;

    dynamicBoost.enable = lib.mkForce true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;
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
    # nur-DataEraserC.packages.${pkgs.system}.cudatoolkit_dev_env_fhs
    pkgs.libva-vdpau-driver
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

  services.sunshine.settings = {
    max_bitrate = 20000; # in Kbps
    # NVIDIA NVENC Encoder
    nvenc_preset = 3; # 1(fastest + worst quality) - 7(slowest + best quality)
    nvenc_twopass = "full_res"; # quarter_res / full_res.
  };
}
