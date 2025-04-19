{config, ...} @ args: {
  imports = [
    ./development_manual.nix
    ./extra_keys.nix
    ./font.nix
    # ./proxychains.nix
    ./sshd.nix
    ./user.nix
    ./nixpkgs.nix
  ];
}
