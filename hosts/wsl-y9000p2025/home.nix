{
  pkgs,
  nur-DataEraserC,
  qqnt,
  ...
}:
{
  # modules.desktop = {
  #   hyprland = {
  #     nvidia = true;
  #     settings = {
  #       # Configure your Display resolution, offset, scale and Monitors here, use `hyprctl monitors` to get the info.
  #       #   highres:      get the best possible resolution
  #       #   auto:         position automatically
  #       #   1.5:          scale to 1.5 times
  #       #   bitdepth,10:  enable 10 bit support
  #       monitor = "eDP-1,2560x1600@60,0x0,1";
  #     };
  #   };
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

      Host zerotier_devices
        HostName 10.147.20.*
        MACs hmac-sha1,hmac-sha1-96,hmac-sha2-256,hmac-sha2-512,hmac-md5
    '';
  };
  home.stateVersion = "24.11";
  home.packages = [
    # qqnt.packages.${pkgs.system}.llqqnt
    # qqnt.packages.${pkgs.system}.bqqnt
  ];
}
