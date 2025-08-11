{
  pkgs,
  pkgs-unstable,
  ...
}:
let
in
{
  home.packages = with pkgs; [
    rsync # File Copy/Snyc
    ranger # Terminal FileManager
    proxychains
    tmux # Background Shell process

    # User-facing stuff that you really really want to have
    vim # or some other editor, e.g. nano or neovim
    helix # An editor with lots of functions out of box
    git # Version Manager
    patch
    direnv

    neofetch
    fastfetch
    openssh
    curl
    gnumake
    just

    # Some common stuff that people expect to have
    fzf
    killall
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzipNLS
    ncurses # command clear
    which
    htop
    tree
    netcat # nc
    procps # command ps/pgrep and ...
    lsof
    time
  ];
  programs = {
    zsh = {
      enable = true;
    };
    nushell = {
      enable = true;
    };
    bash = {
      enable = true;
      enableCompletion = true;
    };
    fish = {
      enable = true;
    };
  };
}
