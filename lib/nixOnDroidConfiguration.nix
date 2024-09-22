{
  inputs,
  lib,
  system,
  genSpecialArgs,
  nix-on-droid-modules,
  home-modules ? [],
  specialArgs ? (genSpecialArgs system),
  myvars,
  ...
}: let
  inherit (inputs) nix-on-droid nixpkgs home-manager;
in
  nix-on-droid.lib.nixOnDroidConfiguration {
    extraSpecialArgs = specialArgs;

    # set nixpkgs instance, it is recommended to apply `nix-on-droid.overlays.default`
    pkgs = import nixpkgs {
      system = "aarch64-linux";

      overlays = [
        nix-on-droid.overlays.default
        # add other overlays
      ];
    };

    modules =
      nix-on-droid-modules
      ++ (
        lib.optionals ((lib.lists.length home-modules) > 0)
        [
          {
            home-manager = {
              config = {imports = home-modules;};
              # Set Home Manager Backup Ext
              backupFileExtension = "hm-bak";
              useGlobalPkgs = true;
              extraSpecialArgs = specialArgs;
            };
          }
        ]
      );

    home-manager-path = home-manager.outPath;
  }
