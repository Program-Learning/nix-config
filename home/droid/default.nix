{
  config,
  catppuccin-urxvt,
  ...
} @ args: {
  imports = [
    ./font.nix
    ./development.nix
    ./creative.nix
    ./menu.nix
    ./dewm.nix
    ./browsers.nix
    ./system-tools.nix
    ./ENV_VAR.nix
    ./others.nix
    # nix-on-droid common
    ./virtualisation.nix
    ./x11_catppuccin.nix
    ./nix.nix
    # common
    ./neovim
    ./fhs.nix
  ];
}
