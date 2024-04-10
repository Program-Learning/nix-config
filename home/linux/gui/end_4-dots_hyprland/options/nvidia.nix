{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktop.end_4-dots_hyprland-hm_module;
in {
  options.modules.desktop.end_4-dots_hyprland-hm_module = {
    nvidia = mkEnableOption "whether nvidia GPU is used";
  };

  config = mkIf (cfg.enable && cfg.nvidia) {
    wayland.windowManager.hyprland.settings.env = [
      # for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/
      "LIBVA_DRIVER_NAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      # fix https://github.com/hyprwm/Hyprland/issues/1520
      "WLR_NO_HARDWARE_CURSORS,1"
      # nvidia-offload
      #"__NV_PRIME_RENDER_OFFLOAD,1"
      #"__NV_PRIME_RENDER_OFFLOAD_PROVIDER,NVIDIA-G0"
      #"__VK_LAYER_NV_optimus,NVIDIA_only"
      #"__GLX_VENDOR_LIBRARY_NAME,nvidia"
    ];
  };
}
