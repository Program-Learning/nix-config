{
  pkgs,
  pkgs-unstable,
  pkgs-latest,
  pkgs-unstable-etcher,
  qqnt,
  nur-linyinfeng,
  nur-xddxdd,
  nur-DataEraserC,
  nur-DataEraserC-not-follow,
  ...
}:
{
  home.packages = with pkgs; [
    # GUI apps
    # e-book viewer(.epub/.mobi/...)
    # do not support .pdf
    foliate
    koodo-reader
    calibre
    # tachiyomi web server for linux
    nur-DataEraserC.packages.${pkgs.system}.suwayomi-server

    # matrix
    # element-desktop
    # this break building
    # cinny-desktop

    # instant messaging
    # telegram-desktop
    ayugram-desktop
    # discord # update too frequently, use the web version instead
    # inter-knot
    nur-DataEraserC.packages.${pkgs.system}.inter-knot

    # remote desktop(rdp connect)
    remmina
    freerdp # required by remmina

    # Download Manager
    motrix
    uget

    # misc
    flameshot
    ventoy # multi-boot usb creator
    pkgs-unstable-etcher.etcher # create bootable usb
    mission-center # Graphical task usage analyzer
    wvkbd # On-screen keyboard for wlroots

    # my custom hardened packages
    # pkgs.nixpaks.qq
    # pkgs.nixpaks.qq-desktop-item
    # qqmusic

    pkgs.bwraps.wechat
    # wechat-uos
    # pkgs.nixpaks.wechat-uos
    # pkgs.nixpaks.wechat-uos-desktop-item
    # nur-linyinfeng.packages.${pkgs.system}.icalingua-plus-plus

    wemeet

    nur-xddxdd.packages.${pkgs.system}.dingtalk

    # wechat-uos
    # nur-DataEraserC.packages.${pkgs.system}.wechat-uos

    # qqnt.packages.${pkgs.system}.llqqnt
    qqnt.packages.${pkgs.system}.bqqnt

    # It is broken and I do not need this now
    # nur-DataEraserC.packages.${pkgs.system}.dingtalk

    feishu

    # c001apk-flutter
    # nur-DataEraserC-not-follow.packages.${pkgs.system}.c001apk-flutter

    # Translate tool
    translate-shell

    # OCR Tool
    tesseract

    # piliplus
    # nur-DataEraserC.packages.${pkgs.system}.piliplus
  ];

  # allow fontconfig to discover fonts and configurations installed through home.packages
  # Install fonts at system-level, not user-level
  fonts.fontconfig.enable = true;
}
