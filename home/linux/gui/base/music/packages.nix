{
  pkgs,
  pkgs-stable,
  ...
}: {
  home.packages = with pkgs; [
    # --Netease music
    pkgs-stable.yesplaymusic
    go-musicfox
  ];
}
