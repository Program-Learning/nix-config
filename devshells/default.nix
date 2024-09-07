{
  lib,
  mylib,
  nixpkgs,
  forAllSystems,
  ...
} @ inputs:
# TODO: fix this
lib.attrsets.recursiveUpdate (import ./mariadb.nix inputs) (import ./development.nix inputs)
# lib.attrsets.mergeAttrsList (builtins.map (array: import array inputs) (mylib.scanPaths ./.))

