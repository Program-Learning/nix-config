{
  pkgs,
  pkgs-stable,
  ...
}: {
  home.packages = with pkgs; [
    pkgs-stable.android-tools
    win2xcur
  ];
}
