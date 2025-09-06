{ pkgs, ... }:
{
  features.clash-nyanpasu = {
    enable = false;
    package = pkgs.clash-nyanpasu;
    tunMode = true;
  };
}
