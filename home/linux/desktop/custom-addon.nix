{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs;
    # nixpkgs here
    [
      warp
      cloudflare-warp
      glib
      calcurse
      #haskell
      ghc
      # nur-no-pkgs.repos.YisuiMilena.hmcl-bin
      minecraft
      # prismlauncher
      # nur-no-pkgs.repos.xddxdd.wine-wechat
      # nur-no-pkgs.repos.linyinfeng.wemeet
      protonup-qt
      appimage-run
      # vim-like browser
      vimb
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
      # video software
      vlc
      # file manager
      gnome.nautilus
      # download manager
      motrix
      wine64Packages.stagingFull
      winetricks
      onscripter-en
      # playonlinux
      # bottles
      # bottles-unwrapped
      lutris
      # lutris-unwrapped
      # remote control
      wayvnc
      # dunst
      # pipewire
      wireplumber
      tofi
      eww-wayland
      rofi-wayland
      polkit-kde-agent
      qt6.qtwayland
      # wayland
      # wayland-scanner
      # wayland-utils
      # egl-wayland
      # wayland-protocols
      # glfw-wayland
      wev
      # libsForQt5.qt5.qtwayland
      # xdg-desktop-portal-hyprland
      linuxKernel.packages.linux_6_1.v4l2loopback
      libsForQt5.polkit-kde-agent
      brightnessctl
      # kitty-themes

      adwaita-qt
      adwaita-qt6
      lxde.lxsession # lxpolkit
      # polkit_gnome
      # deepin.dde-polkit-agent
      hyprpicker
      swappy
      bluez
      sysfsutils
      jq
      wlroots
      # catppuccin-kvantum
      # htop
      vim # file editor
      dolphin # file browser
      postman
      artha
      iw
      file
      coreutils
      openssl
      gitRepo
      # python310 python310.pkgs.pip pipenv
      nodejs
      # php mysql80 apacheHttpd nginxShibboleth # PHP
      php
      php81Packages.composer
      nixfmt
      fuse
      ntfs3g
      foot # terminal
      fish # shell
      scrcpy
      jadx
      meld
      distrobox
      darling-dmg
      dash
      unrar-wrapper
      # python2Full
      inotify-tools
      python311Packages.gpustat
      vmware-workstation

      #-- remote control
      # turbovnc
      xrdp
      libvncserver
      gnome.gnome-remote-desktop
      gnome.gnome-clocks
      # wayvnc
      novnc
      # usb flashing
      ventoy
      # achieve/file managers
      xarchiver mate.engrampa gnome.file-roller ark ranger
      # Graphical application to analyse disk usage in any GNOME environment
      baobab
      # vaapi
      gst_all_1.gst-vaapi
      # payload-dumper
      payload-dumper-go
      # sshfs
      sftpman
      # edge browser
      microsoft-edge
      # sql
      mysql80
      sqliteman

      # pkg required by nix-shell
      pkgconfig
      ncurses6
      # ncurses5
      pkgsCross.aarch64-multiplatform.stdenv.cc
      pkgsCross.arm-embedded.stdenv.cc
      clang15Stdenv
      pkgsLLVM.crossLibcStdenv
      glibc
      libcxx
      zlib
      ninja
    ]
    # nixpkgs-unstable
    ++ (with pkgs-unstable;[
      fastfetch
    ])
    # nur packages here
    ++ (with pkgs.nur.repos; [
      YisuiMilena.hmcl-bin
      linyinfeng.wemeet
      linyinfeng.icalingua-plus-plus
      linyinfeng.matrix-wechat
      xddxdd.wechat-uos
      xddxdd.dingtalk
      xddxdd.bilibili
      xddxdd.onepush
      xddxdd.grasscutter
      ataraxiasjel.waydroid-script
      arti5an.mount-zip
      aleksana.go-musicfox
      # aleksana.fastfetch
      alexnortung.pkgs.papermc-1_18_x

    ]);

  # Custom Desktop Shortcuts
  home.file.".local/share/applications/io.github.msojocs.wechat_devtools.desktop".source = ./shortcuts/io.github.msojocs.wechat_devtools.desktop;
  # home.file.".local/share/applications/code_ime.desktop".source = ./shortcuts/code_ime.desktop;
}
