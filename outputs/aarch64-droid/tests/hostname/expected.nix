{
  lib,
  outputs,
}: let
  hostsNames = builtins.attrNames outputs.nixOnDroidConfigurations;
  # expected = lib.genAttrs hostsNames (name: name);
  expected = lib.genAttrs hostsNames (name: "nix-on-droid");
in
  expected
