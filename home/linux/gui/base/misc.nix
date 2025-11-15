{
  pkgs,
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

    # remote desktop(rdp connect)
    remmina
    freerdp # required by remmina

    # Download Manager
    motrix
    qbittorrent-enhanced
    uget

    # misc
    flameshot
    ventoy # multi-boot usb creator
    pkgs-unstable-etcher.etcher # create bootable usb
    mission-center # Graphical task usage analyzer
    wvkbd # On-screen keyboard for wlroots

    # my custom hardened packages
    # nixpaks.qq
    # nixpaks.telegram-desktop
    # qqmusic
    bwraps.wechat

    #-- instant messaging

    #-- telegram-desktop
    ayugram-desktop

    #-- discord
    # discord # update too frequently, use the web version instead
    # inter-knot
    nur-DataEraserC.packages.${pkgs.system}.inter-knot

    #-- wechat-uos
    # pkgs.nixpaks.wechat-uos
    # pkgs.nixpaks.wechat-uos-desktop-item

    #-- qq
    # nur-linyinfeng.packages.${pkgs.system}.icalingua-plus-plus

    #-- wemeet
    wemeet

    #-- dingtalk
    nur-xddxdd.packages.${pkgs.system}.dingtalk

    # It is broken and I do not need this now
    # nur-DataEraserC.packages.${pkgs.system}.dingtalk

    # wechat-uos
    # nur-DataEraserC.packages.${pkgs.system}.wechat-uos

    # qqnt.packages.${pkgs.system}.llqqnt
    qqnt.packages.${pkgs.system}.bqqnt

    #-- feishu
    feishu

    #-- c001apk-flutter
    # nur-DataEraserC.packages.${pkgs.system}.c001apk-flutter

    # Translate tool
    translate-shell

    # OCR Tool
    tesseract

    #-- piliplus (bilibili)
    piliplus
    # nur-DataEraserC.packages.${pkgs.system}.piliplus
  ];

  # allow fontconfig to discover fonts and configurations installed through home.packages
  # Install fonts at system-level, not user-level
  # NOTE: temporarily set it to true
  fonts.fontconfig.enable = false;
}
