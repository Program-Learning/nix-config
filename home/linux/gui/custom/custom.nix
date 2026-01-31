{
  config,
  lib,
  pkgs,
  pkgs-latest,
  pkgs-stable,
  nur-ryan4yin,
  nur-linyinfeng,
  nur-DataEraserC,
  nur-DataEraserC-not-follow,
  nur-ataraxiaSjel,
  hyprland-plugins,
  hyprland,
  ...
}:
let
  cfgGnomeWayland = config.modules.desktop.gnome-wayland;
in
{
  home.packages =
    (
      with pkgs;
      # nixpkgs here
      [
        # test only
        # niri
        mount-zip
        # AutoClick tool
        xdotool
        dotool
        ydotool
        wlrctl
        wtype

        # trickle
        # use this to pop a input window
        zenity
        jansson
        nftables
        cachix
        # weston
        libsForQt5.qtstyleplugin-kvantum
        adwaita-icon-theme

        # --nvidia cuda
        # cudatoolkit

        # Bilibili video download
        yutto

        # ytb video download
        yt-dlp

        # kdePackages.konsole
        # powerdevil

        # calcurse

        # --vim-like browser
        # vimb

        # --agent
        protonvpn-gui
        # clash-nyanpasu
        # throne
        sing-box
        # cloudflare-warp
        wgcf

        # --Office
        onlyoffice-desktopeditors
        libreoffice
        # mdp
        # slides
        wpsoffice-cn # unfree
        stirling-pdf

        # --math software
        # geogebra6

        # --achieve/file managers
        # xarchiver
        # mate.engrampa
        nautilus
        nautilus-open-any-terminal
        file-roller
        # kdePackages.ark
        # kdePackages.dolphin
        # ranger

        qrencode

        gnome-clocks

        # dunst
        # pipewire
        # wireplumber
        # tofi
        # eww
        # rofi-wayland
        # qt6.qtwayland
        # wayland
        # wayland-scanner
        # wayland-utils
        # egl-wayland
        # wayland-protocols
        # glfw-wayland
        # libsForQt5.qt5.qtwayland
        # hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
        libsForQt5.qt5ct
        # kitty-themes

        # adwaita-qt
        # adwaita-qt6
        # lxde.lxsession # lxpolkit
        polkit_gnome_exported
        swappy
        bluez
        sysfsutils
        # jq
        # wlroots
        # catppuccin-kvantum
        # htop
        vim # file editor
        # postman
        # artha
        iw
        # coreutils
        # openssl
        gitRepo
        fuse
        ntfs3g
        jadx
        meld
        # dash
        inotify-tools
        # vmware-workstation

        # vaapi
        gst_all_1.gst-vaapi
        # sshfs
        # sftpman
        # edge browser
        # microsoft-edge
        # sql
        # mysql80

        # pkg required by nix-shell
        pkg-config
        # ncurses
        # ncurses6
        # ncurses5
        # pkgsCross.aarch64-multiplatform.stdenv.cc
        # pkgsCross.arm-embedded.stdenv.cc
        #clang15Stdenv
        #pkgsLLVM.crossLibcStdenv
        # clang-tools
        # glibc
        # libcxx
        # zlib
        # ninja

        ntfy-sh
      ])
    # nur packages here
    ++ (
      # with pkgs.nur.repos;
      [
        # YisuiMilena.hmcl-bin
        # nur-linyinfeng.packages.${pkgs.system}.matrix-wechat
        nur-DataEraserC.packages.${pkgs.system}.baidunetdisk
        nur-DataEraserC.packages.${pkgs.system}.baidupcs-go
        # bilibili is broken
        # nur-DataEraserC.packages.${pkgs.system}.bilibili
        # nur-ataraxiaSjel.packages.${pkgs.system}.waydroid-script
        # steam++ is broken
        # nur-DataEraserC.packages.${pkgs.system}.watt-toolkit_bin
        # nur-DataEraserC.packages.${pkgs.system}.cisco-packet-tracer # network learning
        # nur-DataEraserC.packages.${pkgs.system}.AppimageLauncher_deb
        nur-DataEraserC.packages.${pkgs.system}.XiaoMiToolV2
        # nur-DataEraserC.packages.${pkgs.system}.CrossOver
        # nur-DataEraserC.packages.${pkgs.system}.waybar-bluetooth_battery_parse
        # alexnortung.pkgs.papermc-1_18_x
      ]);

  services = {
    kdeconnect = lib.mkIf (!cfgGnomeWayland.enable) {
      enable = true;
      indicator = true;
      # kdeconnect.package = pkgs.kdePackages.kdeconnect-kde;
    };
  };
}
