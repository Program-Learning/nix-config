{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "foot";
  };
  services.gnome.sushi.enable = true;
}
