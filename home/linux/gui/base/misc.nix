{
  pkgs,
  pkgs-unstable,
  pkgs-latest,
  pkgs-unstable-etcher,
  llqqnt,
  nur-linyinfeng,
  nur-DataEraserC,
  ...
}: {
  home.packages = with pkgs; [
    # GUI apps
    # e-book viewer(.epub/.mobi/...)
    # do not support .pdf
    foliate
    koodo-reader

    # instant messaging
    telegram-desktop
    discord

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
    pkgs.nixpaks.qq
    pkgs.nixpaks.qq-desktop-item

    # nur-linyinfeng.packages.${pkgs.system}.icalingua-plus-plus

    nur-linyinfeng.packages.${pkgs.system}.wemeet

    # wechat-uos
    nur-DataEraserC.packages.${pkgs.system}.wechat-uos

    nur-DataEraserC.packages.${pkgs.system}.dingtalk

    pkgs-latest.feishu
  ];

  # GitHub CLI tool
  programs.gh = {
    enable = true;
  };

  # allow fontconfig to discover fonts and configurations installed through home.packages
  # Install fonts at system-level, not user-level
  fonts.fontconfig.enable = false;
}
