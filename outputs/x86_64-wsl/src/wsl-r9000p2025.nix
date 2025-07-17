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
  ...
} @ args: let
  # r9000p2025
  name = "r9000p2025";
  wsl-modules = [
    inputs.nixos-wsl.nixosModules.default
  ];
  base-modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        # common
        "secrets/options.nix"
        "secrets/nixos_agenix.nix"
        "secrets/nixos_sopsnix.nix"
        "modules/nixos/server/wsl.nix"
        # host specific
        "hosts/wsl-${name}"
      ])
      ++ [
        inputs.vscode-server.nixosModules.default
        ({
          config,
          pkgs,
          ...
        }: {
          services.vscode-server.enable = true;
        })
        {
          modules.mkOutOfStoreSymlink.enable = true;
          modules.mkOutOfStoreSymlink.configPath = "/home/nixos/nix-config";
          modules.mkOutOfStoreSymlink.wallpaperPath = "/home/nixos/Documents/code/wallpapers";
        }
      ];
    home-modules =
      map mylib.relativeToRoot [
        # common
        "home/linux/tui.nix"
        # host specific
        "hosts/wsl-${name}/home.nix"
      ]
      ++ [
        {
          modules.mkOutOfStoreSymlink.enable = true;
          modules.mkOutOfStoreSymlink.configPath = "/home/nixos/nix-config";
          modules.mkOutOfStoreSymlink.wallpaperPath = "/home/nixos/Documents/code/wallpapers";
        }
      ];
  };

  modules-hyprland = {
    nixos-modules =
      [
        {
          # modules.desktop.wayland.enable = false;
          modules.secrets.desktop.enable = true;
          modules.secrets.preservation.enable = true;
        }
      ]
      ++ base-modules.nixos-modules
      ++ wsl-modules;
    home-modules =
      [
        # {modules.desktop.hyprland.enable = false;}
      ]
      ++ base-modules.home-modules;
  };
in {
  nixosConfigurations = {
    # host with hyprland compositor
    "wsl-${name}" = mylib.nixosSystem (modules-hyprland // args);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "wsl-${name}" = inputs.self.nixosConfigurations."wsl-${name}".config.formats.iso;
  };
}
