let
  intel_card = "/dev/dri/card0";
  nvidia_card = "/dev/dri/card1";
in {
  modules.desktop = {
    hyprland = {
      nvidia = false;
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
      Host *
          ForwardAgent yes
          IdentityFile ~/.ssh/y9000k2021h_id_ed25519
          IdentitiesOnly yes

      Host github.com
          # github is controlled by gluttony~
          IdentityFile ~/.ssh/y9000k2021h_id_ed25519
          # Specifies that ssh should only use the identity file explicitly configured above
          # required to prevent sending default identity files first.
          IdentitiesOnly yes

      Host oracle_ubuntu_1
        HostName 155.248.179.129
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes

      Host mondrian_1_school
        HostName 192.168.0.121
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes

      Host mondrian_1_home
        HostName 192.168.2.121
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes

      Host pstar_1_school
        HostName 192.168.0.123
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes

      Host pstar_1_home
        HostName 192.168.2.123
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes

      Host y9000k2021h_1_school
        HostName 192.168.0.120
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes

      Host y9000k2021h_1_home
        HostName 192.168.2.120
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes

      Host y9000k2021h_1_zerotier
        HostName 10.147.20.120
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes

      Host y9000k2021h_1_tailscale
        HostName 100.95.7.36
        ForwardAgent yes
        IdentityFile ~/.ssh/y9000k2021h_id_ed25519
        IdentitiesOnly yes
    '';
  };

  xdg.configFile = {
    "gpus/intel_card".source = /. + "/dev/dri/by-path/pci-0000:00:02.0-card";
    "gpus/nvidia_card".source = /. + "/dev/dri/by-path/pci-0000:01:00.0-card";
  };
}
