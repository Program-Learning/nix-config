{
  pkgs,
  pkgs-stable,
  nur-DataEraserC,
  pkgs-latest,
  fakedroid,
  ...
}: {
  home.packages = with pkgs; [
    # nur-DataEraserC.packages.${pkgs.system}.qtscrcpy_git
    nur-DataEraserC.packages.${pkgs.system}.escrcpy_deb
    gnirehtet
    scrcpy
    libmtp
    adb-sync
    abootimg
    pkgs-stable.android-tools
    pkgs-latest.android-studio
    genymotion
    edl
    # --payload-dumper
    payload-dumper-go
    # fakedroid.packages.${pkgs.system}.fakedroid

    win2xcur
  ];
}
