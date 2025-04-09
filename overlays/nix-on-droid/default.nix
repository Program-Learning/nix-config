args: let
  is_nix_on_droid =
    if args ? "nix-on-droid"
    then args."nix-on-droid"
    else false;
in
  if is_nix_on_droid == true
  then
    # execute and import all overlay files in the current directory with the given args
    (builtins.map
      (f: (import (./. + "/${f}") args)) # execute and import the overlay file
      
      (builtins.filter # find all overlay files in the current directory
        
        (
          f:
            f
            != "default.nix" # ignore default.nix
            && f != "README.md" # ignore README.md
        )
        (builtins.attrNames (builtins.readDir ./.))))
  else []
