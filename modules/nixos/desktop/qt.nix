{
  pkgs,
  lib,
  ...
}: {
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };
}
