{ lib, ... }@args:
# execute and import all overlay files in the current directory with the given args
lib.concatMap
  (
    f:
    let
      overlay = import (./. + "/${f}") args;
    in
    if lib.isList overlay then overlay else [ overlay ]
  ) # execute and import the overlay file

  (
    builtins.filter # find all overlay files in the current directory

      (
        f:
        f != "default.nix" # ignore default.nix
        && f != "README.md" # ignore README.md
      )
      (builtins.attrNames (builtins.readDir ./.))
  )
