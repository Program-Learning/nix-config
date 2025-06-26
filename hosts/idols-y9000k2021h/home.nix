{config, ...}: {
  modules.desktop = {
    hyprland = {
      nvidia = true;
      settings.source = [
        "${config.home.homeDirectory}/nix-config/hosts/idols-ai/hypr-hardware.conf"
      ];
    };
  };

  programs.ssh.matchBlocks."github.com".identityFile = "${config.home.homeDirectory}/.ssh/y9000k2021h_id_ed25519";
}
