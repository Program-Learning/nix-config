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
  inherit (inputs) nix-on-droid nixpkgs-nod home-manager-nod;
in
  nix-on-droid.lib.nixOnDroidConfiguration {
    inherit system specialArgs;
    extraSpecialArgs = specialArgs;

    # set nixpkgs instance, it is recommended to apply `nix-on-droid.overlays.default`
    pkgs = import nixpkgs-nod {
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
              config = home-modules;
              backupFileExtension = "hm-bak";
              useGlobalPkgs = true;
            };
          }
        ]
      );

    home-manager-path = home-manager-nod.outPath;
  }
