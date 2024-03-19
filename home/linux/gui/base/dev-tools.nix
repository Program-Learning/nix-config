{pkgs, ...}: {
  home.packages = with pkgs; [
    android-tools
    win2xcur
  ];
}
