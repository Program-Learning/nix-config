{ pkgs, ... }: {
  home.packages = with pkgs; [
    # nur-no-pkgs.repos.YisuiMilena.hmcl-bin
    minecraft
    # prismlauncher
    # nur-no-pkgs.repos.xddxdd.wine-wechat
    # nur-no-pkgs.repos.linyinfeng.wemeet
    protonup-qt
    # Netease music
    yesplaymusic
    clash-verge
    sing-box
    # Office
    onlyoffice-bin
    libreoffice
    # math software
    # geogebra6
    # communication apps
    tdesktop
    # qq
    # web browsers
    # firefox
    # google-chrome
    # screen capture
    # obs-studio
    grim
    # wf-recorder
    # video software
    # mpv
    vlc
    # file manager
    gnome.nautilus
    # download manager
    motrix
    wineWowPackages.waylandFull
    winetricks
    onscripter-en
    # playonlinux
    # bottles
    # bottles-unwrapped
    lutris
    # lutris-unwrapped
    # remote control
    wayvnc
    remmina
    # networkmanagerapplet
    # swayidle
    # swaylock
    # dunst
    # pipewire
    wireplumber
    # swaybg
    tofi
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true " ];
    }))
    eww-wayland
    rofi-wayland
    polkit-kde-agent
    # udiskie
    qt6.qtwayland
    wl-clipboard
    wayland
    wayland-scanner
    wayland-utils
    egl-wayland
    wayland-protocols
    glfw-wayland
    xwayland
    wev
    wf-recorder
    alsa-lib
    alsa-utils
    mako
    libsForQt5.qt5.qtwayland
    xdg-desktop-portal-hyprland
    libsForQt5.polkit-kde-agent
    brightnessctl
    libnotify
    hyprpaper
    kitty
    kitty-themes

    adwaita-qt
    adwaita-qt6
    pavucontrol
    lxde.lxsession # lxpolkit
    # polkit_gnome
    # deepin.dde-polkit-agent
    grim # ScreenShot
    slurp
    hyprpicker
    swappy
    blueman
    bluez
    # wlogout
    playerctl
    sysfsutils
    socat
    jq
    wlroots
    catppuccin-kvantum
    pciutils
    # neofetch
    # htop btop
    vim # file editor
    ranger dolphin # file browser
    tmux
    killall
    postman
    artha
    wget iw
    file
    coreutils openssl
    git gitRepo aria
    gcc gdb cmake gnumake unzip
    go_1_20
    # python310 python310.pkgs.pip pipenv
    nodejs
    # php mysql80 apacheHttpd nginxShibboleth # PHP
    nixfmt
    sqlite
    fuse ntfs3g
    foot # terminal
    fish # shell
    android-tools # adb, fastboot, etc
    scrcpy
    jadx meld
    ffmpeg-full
    docker docker-compose
    distrobox
    darling-dmg darling
    # gdu
    dash
    p7zip
    unrar-wrapper
    # python2Full
    # fzf
    inotify-tools
    python311Packages.gpustat
    vmware-workstation
    waydroid
    
    #-- remote control
    # turbovnc
    freerdp
    xrdp
    libvncserver
    gnome.gnome-remote-desktop
    # wayvnc
    novnc

    proxychains
  ];

}
