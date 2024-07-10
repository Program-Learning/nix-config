{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  nixos-wsl,
  ...
} @ args: let
  # y9000k2021h
  name = "y9000k2021h";
  wsl-modules = [
    nixos-wsl.nixosModules.default
  ];
  base-modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      "secrets/nixos.nix"
      "modules/nixos/server/server.nix"
      # host specific
      "hosts/wsl-${name}"
    ];
    home-modules = map mylib.relativeToRoot [
      # common
      "home/linux/tui.nix"
      # host specific
      "hosts/wsl-${name}/home.nix"
    ];
  };

  modules-i3 = {
    nixos-modules =
      [
        {
          # modules.desktop.xorg.enable = true;
          # modules.secrets.desktop.enable = true;
          modules.secrets.impermanence.enable = true;
        }
      ]
      ++ base-modules.nixos-modules ++ wsl-modules;
    home-modules =
      [
        # {modules.desktop.i3.enable = true;}
      ]
      ++ base-modules.home-modules;
  };

  modules-hyprland = {
    nixos-modules =
      [
        {
          # modules.desktop.wayland.enable = true;
          # modules.secrets.desktop.enable = true;
          modules.secrets.impermanence.enable = true;
        }
      ]
      ++ base-modules.nixos-modules ++ wsl-modules;
    home-modules =
      [
        # {modules.desktop.hyprland.enable = true;}
      ]
      ++ base-modules.home-modules;
  };
in {
  nixosConfigurations = {
    # with i3 window manager
    "wsl-${name}-i3" = mylib.nixosSystem (modules-i3 // args);
    # host with hyprland compositor
    "wsl-${name}-hyprland" = mylib.nixosSystem (modules-hyprland // args);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "wsl-${name}-i3" = inputs.self.nixosConfigurations."wsl-${name}-i3".config.formats.iso;
    "wsl-${name}-hyprland" = inputs.self.nixosConfigurations."wsl-${name}-hyprland".config.formats.iso;
  };
}
