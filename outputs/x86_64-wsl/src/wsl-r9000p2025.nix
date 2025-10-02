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
}@args:
let
  # r9000p2025
  name = "r9000p2025";
  wsl-modules = {
    nixos-modules = [ inputs.nixos-wsl.nixosModules.default ];
  };
  base-modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        # common
        "secrets/options.nix"
        "secrets/nixos_agenix.nix"
        "secrets/nixos_sopsnix.nix"
        "modules/nixos/wsl"
        # host specific
        "hosts/wsl-${name}"
        # nixos hardening
        # "hardening/profiles/default.nix"
        "hardening/nixpaks"
        "hardening/bwraps"
      ])
      ++ [
        inputs.vscode-server.nixosModules.default
        {
          modules.secrets.desktop.enable = true;
          modules.secrets.preservation.enable = true;
        }
        (
          {
            config,
            pkgs,
            ...
          }:
          {
            services.vscode-server.enable = true;
          }
        )
        {
          modules.mkOutOfStoreSymlink.enable = true;
          modules.mkOutOfStoreSymlink.configPath = "/home/nixos/nix-config";
          modules.mkOutOfStoreSymlink.wallpaperPath = "/home/nixos/Documents/code/wallpapers";
        }
      ];
    home-modules =
      map mylib.relativeToRoot [
        # common
        "home/linux/wsl.nix"
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

  modules = {
    nixos-modules = [
      {
        modules.desktop.fonts.enable = true;
        # modules.desktop.wayland.enable = true;
        modules.secrets.desktop.enable = true;
        modules.secrets.preservation.enable = true;
        # modules.desktop.niri.enable = true;
      }
    ]
    ++ base-modules.nixos-modules
    ++ wsl-modules.nixos-modules;
    home-modules = [
      # { modules.desktop.niri.enable = true; }
    ]
    ++ base-modules.home-modules;
  };
in
{
  nixosConfigurations = {
    # host with hyprland compositor
    "wsl-${name}" = mylib.nixosSystem (modules // args);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "wsl-${name}" = inputs.self.nixosConfigurations."wsl-${name}".config.formats.iso;
  };
}
