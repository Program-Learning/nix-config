{ mylib, lib, ... }:
{
  imports = builtins.filter (
    path:
    let
      name = baseNameOf path;
    in
    !lib.elem name [
      "editors"
      "default.nix"
      "wsl.nix"
    ]
  ) (mylib.scanPaths ./.);
}
