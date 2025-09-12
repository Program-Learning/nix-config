{ pkgs, ... }:
{
  features.mihomo-party = {
    enable = false;
    autoStart = true;
    tunMode = true;
    # package = pkgs.mihomo-party;
  };
}
