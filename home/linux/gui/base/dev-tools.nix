{
  pkgs,
  pkgs-stable,
  nur-program-learning,
  fakedroid,
  ...
}: {
  home.packages = with pkgs; [
    # nur-program-learning.packages.${pkgs.system}.qtscrcpy_git
    nur-program-learning.packages.${pkgs.system}.escrcpy_deb
    gnirehtet
    scrcpy
    libmtp
    adb-sync
    abootimg
    pkgs-stable.android-tools
    android-studio
    genymotion
    edl
    # --payload-dumper
    payload-dumper-go
    # fakedroid.packages.${pkgs.system}.fakedroid

    win2xcur
  ];
}
