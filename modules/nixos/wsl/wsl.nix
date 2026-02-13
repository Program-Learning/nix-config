{ lib, ... }:
{
  imports = [
    ../server/server.nix
    ../desktop/fonts.nix
    ../desktop/fhs.nix
    ./gpg.nix
  ];
}
