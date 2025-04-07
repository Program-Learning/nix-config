{
  pkgs,
  pkgs-stable,
  nur-DataEraserC,
  pkgs-latest,
  fakedroid,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    # nur-DataEraserC.packages.${pkgs.system}.qtscrcpy_git
    nur-DataEraserC.packages.${pkgs.system}.escrcpy_deb
    nur-DataEraserC.packages.${pkgs.system}.magiskboot
    apksigner
    gnirehtet
    scrcpy
    libmtp
    adb-sync
    abootimg
    android-tools
    android-studio
    # genymotion
    # edl
    # --payload-dumper
    payload-dumper-go
    # fakedroid.packages.${pkgs.system}.fakedroid

    win2xcur
  ];
}
