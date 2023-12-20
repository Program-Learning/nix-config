args:
with args; let
  nixosSystem = import ../lib/nixosSystem.nix;

  base_args = {
    inherit home-manager nixos-generators;
    inherit nixpkgs; # or nixpkgs-unstable
    system = x64_system;
    specialArgs = x64_system_specialArgs;
  };
in {
  nixosConfigurations = {
    # y9000k2021h with i3 window manager
    y9000k2021h_i3 = nixosSystem (idol_y9000k2021h_modules_i3 // base_args);
    # y9000k2021h with hyprland compositor
    y9000k2021h_hyprland = nixosSystem (idol_y9000k2021h_modules_hyprland // base_args);
      
    # ai with i3 window manager
    ai_i3 = nixosSystem (idol_ai_modules_i3 // base_args);
    # ai with hyprland compositor
    ai_hyprland = nixosSystem (idol_ai_modules_hyprland // base_args);

    # three virtual machines without desktop environment.
    aquamarine = nixosSystem (idol_aquamarine_modules // base_args);
    ruby = nixosSystem (idol_ruby_modules // base_args);
    kana = nixosSystem (idol_kana_modules // base_args);
  };

  # take system images for idols
  # https://github.com/nix-community/nixos-generators
  packages."${x64_system}" =
    # genAttrs returns an attribute set with the given keys and values(host => image).
    nixpkgs.lib.genAttrs [
      "ai_i3"
      "ai_hyprland"
    ]
    (
      # generate iso image for hosts with desktop environment
      host:
        self.nixosConfigurations.${host}.config.formats.iso
    )
    // nixpkgs.lib.genAttrs [
      "aquamarine"
      "ruby"
      "kana"
    ]
    (
      # generate proxmox image for virtual machines without desktop environment
      host:
        self.nixosConfigurations.${host}.config.formats.proxmox
    );
}
