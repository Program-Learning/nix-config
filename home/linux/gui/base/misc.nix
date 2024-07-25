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
    # temporarily fix for https://github.com/NixOS/nixpkgs/commit/7e3940735af718435c7f34cbc1f0f9c0105e8159
    # pkgs-unstable.qq # https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/networking/instant-messengers/qq
    llqqnt.packages.${pkgs.system}.llqqnt
    # nur-linyinfeng.packages.${pkgs.system}.icalingua-plus-plus

    nur-linyinfeng.packages.${pkgs.system}.wemeet

    # wechat-uos
    nur-DataEraserC.packages.${pkgs.system}.wechat-uos

    nur-DataEraserC.packages.${pkgs.system}.dingtalk

    pkgs-latest.feishu

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
  ];

  # GitHub CLI tool
  programs.gh = {
    enable = true;
  };

  # allow fontconfig to discover fonts and configurations installed through home.packages
  # Install fonts at system-level, not user-level
  fonts.fontconfig.enable = false;
}
