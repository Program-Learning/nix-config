{pkgs, ...}: {
  home.packages = with pkgs; [
    # --Netease music
    yesplaymusic
    go-musicfox
  ];
}
