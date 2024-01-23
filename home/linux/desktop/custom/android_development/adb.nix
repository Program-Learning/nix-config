{pkgs, ...}: {
  home.packages = with pkgs; [
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
