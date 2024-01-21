{
  modules.desktop = {
    hyprland = {
      nvidia = true;
      settings = {
        # Configure your Display resolution, offset, scale and Monitors here, use `hyprctl monitors` to get the info.
        #   highres:      get the best possible resolution
        #   auto:         postition automatically
        #   1.5:          scale to 1.5 times
        #   bitdepth,10:  enable 10 bit support
        monitor = "eDP-1,2560x1600@60,0x0,1";
      };
    };
    i3.nvidia = true;
  };
  modules.editors.emacs = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
          # github is controlled by gluttony~
          IdentityFile ~/.ssh/y9000k2021h_id_ed25519
          # Specifies that ssh should only use the identity file explicitly configured above
          # required to prevent sending default identity files first.
          IdentitiesOnly yes

      Host mondrian_1_school
        HostName 192.168.0.121
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes

      Host pstar_1_school
        HostName 192.168.0.123
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes

      Host y9000k2021h_1_school
        HostName 192.168.0.120
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes
      Host oracle_ubuntu_1
        HostName 155.248.179.129
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes
    '';
  };
}
