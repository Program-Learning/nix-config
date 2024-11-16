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
  # 星野 アイ, Hoshino Ai
  name = "ai";
  base-modules = {
    nixos-modules =
      map mylib.relativeToRoot [
        # common
        "secrets/nixos.nix"
        "modules/nixos/desktop.nix"
        # host specific
        "hosts/idols-${name}"
        # nixos hardening
        # "hardening/profiles/default.nix"
        "hardening/nixpaks"
        # "hardening/apparmor"
      ]
      ++ [
        inputs.daeuniverse.nixosModules.dae
        inputs.daeuniverse.nixosModules.daed
        inputs.chaotic.nixosModules.default
      ];
    home-modules = map mylib.relativeToRoot [
      # common
      "home/linux/gui.nix"
      # host specific
      "hosts/idols-${name}/home.nix"
    ];
  };

  modules-gnome-wayland = {
    nixos-modules =
      [
        {
          modules.desktop.gnome-wayland.enable = true;
          modules.secrets.desktop.enable = true;
          modules.secrets.impermanence.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        {modules.desktop.gnome-wayland.enable = true;}
      ]
      ++ base-modules.home-modules;
  };
  modules-kde-wayland = {
    nixos-modules =
      [
        {
          modules.desktop.kde-wayland.enable = true;
          modules.secrets.desktop.enable = true;
          modules.secrets.impermanence.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        {modules.desktop.kde-wayland.enable = true;}
      ]
      ++ base-modules.home-modules;
  };

  modules-hyprland = {
    nixos-modules =
      [
        {
          modules.desktop.wayland.enable = true;
          modules.secrets.desktop.enable = true;
          modules.secrets.impermanence.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        {modules.desktop.hyprland.enable = true;}
      ]
      ++ base-modules.home-modules;
  };
in {
  nixosConfigurations = {
    # with gnome-wayland window manager
    "${name}-gnome-wayland" = mylib.nixosSystem (modules-gnome-wayland // args);
    # with kde-wayland window manager
    "${name}-kde-wayland" = mylib.nixosSystem (modules-kde-wayland // args);
    # host with hyprland compositor
    "${name}-hyprland" = mylib.nixosSystem (modules-hyprland // args);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "${name}-gnome-wayland" = inputs.self.nixosConfigurations."${name}-gnome-wayland".config.formats.iso;
    "${name}-kde-wayland" = inputs.self.nixosConfigurations."${name}-kde-wayland".config.formats.iso;
    "${name}-hyprland" = inputs.self.nixosConfigurations."${name}-hyprland".config.formats.iso;
  };
}
