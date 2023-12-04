{
  pkgs,
  nur-program-learning,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./creative.nix
    ./gtk.nix
    ./immutable-file.nix
    ./media.nix
    ./ssh.nix
    ./wallpaper.nix
    ./xdg.nix
    ./custom-addon.nix
  ];

  home.packages = with pkgs; [
    # GUI apps
    insomnia # REST client
    wireshark # network analyzer

    # e-book viewer(.epub/.mobi/...)
    # do not support .pdf
    foliate

    # instant messaging
    telegram-desktop
    discord
    qq # https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/networking/instant-messengers/qq
    # nur-program-learning.packages.${pkgs.system}.llqqnt
    # remote desktop(rdp connect)
    remmina
    freerdp # required by remmina

    # misc
    flameshot
    mitmproxy # http/https proxy tool
  ];

  # GitHub CLI tool
  programs.gh = {
    enable = true;
  };
}
