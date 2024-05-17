{
  pkgs,
  pkgs-unstable,
  llqqnt,
  ...
}: {
  home.packages = with pkgs; [
    # GUI apps
    # e-book viewer(.epub/.mobi/...)
    # do not support .pdf
    foliate

    # instant messaging
    telegram-desktop
    discord
    # temporarily fix for https://github.com/NixOS/nixpkgs/commit/7e3940735af718435c7f34cbc1f0f9c0105e8159
    # pkgs-unstable.qq # https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/networking/instant-messengers/qq
    llqqnt.packages.${pkgs.system}.llqqnt
    wechat-uos
    feishu

    # remote desktop(rdp connect)
    remmina
    freerdp # required by remmina

    # Download Manager
    motrix
    uget

    # misc
    flameshot
    ventoy # multi-boot usb creator
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
