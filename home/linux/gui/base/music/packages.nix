{
  pkgs,
  pkgs-stable,
  ...
}: {
  home.packages = with pkgs; [
    # --Netease music
    # NOTE: YesPlayMusic has been removed as it was broken, unmaintained, and used deprecated Node and Electron versions
    # pkgs-stable.yesplaymusic
    go-musicfox
  ];
}
