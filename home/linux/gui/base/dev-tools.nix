{
  pkgs,
  pkgs-stable,
  nur-DataEraserC,
  nur-DataEraserC-not-follow,
  pkgs-latest,
  fakedroid,
  Snowpkgs,
  atl-nix,
  ...
}:
{
  home.packages = with pkgs; [
    # -- android related
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
    # disable bcs can not be built
    # Snowpkgs.packages.${pkgs.system}.android-translation-layer
    atl-nix.packages.${pkgs.system}.default
    # genymotion
    # edl
    # --payload-dumper
    payload-dumper-go
    # fakedroid.packages.${pkgs.system}.fakedroid

    win2xcur
    # flutter server box
    server-box
    # nur-DataEraserC.packages.${pkgs.system}.flutter_server_box
  ];
}
