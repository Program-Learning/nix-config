{
  pkgs,
  lib,
  ...
}:
{
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
