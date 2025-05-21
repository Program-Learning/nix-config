{config, ...}: {
  modules.desktop = {
    hyprland = {
      nvidia = true;
      settings = {
        # Configure your Display resolution, offset, scale and Monitors here, use `hyprctl monitors` to get the info.
        #   highres:      get the best possible resolution
        #   auto:         position automatically
        #   1.5:          scale to 1.5 times
        #   bitdepth,10:  enable 10 bit support
        monitor = "eDP-1,highres,auto,1.6";
        xwayland.force_zero_scaling = true;
        env = [
          "GDK_SCALE,2"
          "ELM_SCALE,1.5"
        ];
      };
    };
  };

  programs.ssh.matchBlocks."github.com".identityFile = "${config.home.homeDirectory}/.ssh/y9000k2021h_id_ed25519";
}
