{pkgs, ...}: {
  home.packages = with pkgs; [
    baobab # Graphical disk usage analyzer
  ];
}
