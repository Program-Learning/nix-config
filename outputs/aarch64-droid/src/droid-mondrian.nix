{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  mylib,
  myvars,
  system,
  genSpecialArgs,
  ...
} @ args: let
  name = "mondrian";

  modules = {
    nix-on-droid-modules =
      (map mylib.relativeToRoot [
        # common
        # "secrets/droid.nix"
        "modules/droid"
        # host specific
        "hosts/droid-${name}"
      ])
      ++ [];
    home-modules = map mylib.relativeToRoot [
      # common
      #"home/linux/gui.nix"
      "home/droid"
      # host specific
      "hosts/droid-${name}/home.nix"
    ];
  };

  systemArgs = modules // args;
in {
  # droid's configuration
  nixOnDroidConfigurations.${name} = mylib.nixOnDroidConfiguration systemArgs;
}
