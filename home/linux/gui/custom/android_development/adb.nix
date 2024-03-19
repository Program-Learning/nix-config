{
  pkgs,
  nur-program-learning,
  ...
}: {
  home.packages = with pkgs; [
    nur-program-learning.packages.${pkgs.system}.qtscrcpy_git
    nur-program-learning.packages.${pkgs.system}.escrcpy_appimage
    gnirehtet
    scrcpy
    libmtp
    adb-sync
    abootimg
    android-studio
    android-tools
    edl
    genymotion
    # --payload-dumper
    payload-dumper-go
  ];
}
