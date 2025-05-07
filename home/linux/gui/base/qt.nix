{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # xcb-util-cursor
  ];
}
