{
  # modules.desktop = {
  #   hyprland = {
  #     nvidia = false;
  #     settings = {
  #       # Configure your Display resolution, offset, scale and Monitors here, use `hyprctl monitors` to get the info.
  #       #   highres:      get the best possible resolution
  #       #   auto:         position automatically
  #       #   1.5:          scale to 1.5 times
  #       #   bitdepth,10:  enable 10 bit support
  #       monitor = "eDP-1,2560x1600@60,0x0,1";
  #     };
  #   };
  #   i3.nvidia = false;
  # };
  # modules.editors.emacs = {
  #   enable = true;
  # };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          ForwardAgent yes
          IdentityFile ~/.ssh/y9000k2021h_id_ed25519
          IdentitiesOnly yes

      Host github.com
          IdentityFile ~/.ssh/y9000k2021h_id_ed25519
          # Specifies that ssh should only use the identity file explicitly configured above
          # required to prevent sending default identity files first.
          IdentitiesOnly yes
    '';
  };
  home.stateVersion = "24.05";
}
