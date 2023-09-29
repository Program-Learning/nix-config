{ config, pkgs, pkgs-unstable, ... }: {
  home.packages = (with pkgs;
  # nixpkgs here
    [
      mpvpaper
      # --nvidia cuda
      cudatoolkit

      # bilibili
      yutto

      konsole
      powerdevil

      # --android
      gnirehtet
      libmtp
      adb-sync
      android-studio
      # --payload-dumper
      payload-dumper-go

      # --java ide
      # jetbrains.idea-ultimate
      jetbrains.idea-community
      eclipses.eclipse-sdk

      # --mc
      pkgs-unstable.hmcl
      # minecraft
      # prismlauncher

      warp
      cloudflare-warp

      glib
      calcurse

      # --haskell
      ghc

      appimage-run

      # --vim-like browser
      vimb

      # --Netease music
      yesplaymusic

      # --agent
      clash-verge
      sing-box

      # --Office
      onlyoffice-bin
      libreoffice

      # --math software
      # geogebra6

      # --communication apps

      # --video software
      vlc

      # --achieve/file managers
      xarchiver
      mate.engrampa
      gnome.nautilus
      gnome.file-roller
      ark
      dolphin
      ranger

      # --download manager
      motrix

      # --wine
      protonup-qt
      wine-staging
      # wine64Packages.stagingFull
      # winePackages.stagingFull
      winetricks
      onscripter-en
      # playonlinux
      # bottles
      # bottles-unwrapped
      lutris
      # lutris-unwrapped

      # --remote control
      wayvnc
      # turbovnc
      xrdp
      libvncserver
      gnome.gnome-remote-desktop
      gnome.gnome-clocks
      novnc

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

      # --usb flashing
      ventoy

      # --Graphical application to analyse disk usage in any GNOME environment
      baobab

      # vaapi
      gst_all_1.gst-vaapi
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
    ])
  # nixpkgs-unstable
    ++ (with pkgs-unstable; [ fastfetch ])
    # nur packages here
    ++ (with pkgs.nur.repos; [
      # YisuiMilena.hmcl-bin
      linyinfeng.wemeet
      linyinfeng.icalingua-plus-plus
      linyinfeng.matrix-wechat
      xddxdd.wechat-uos
      xddxdd.dingtalk
      # xddxdd.bilibili
      xddxdd.onepush
      xddxdd.grasscutter
      ataraxiasjel.waydroid-script
      arti5an.mount-zip
      aleksana.go-musicfox
      # aleksana.fastfetch
      alexnortung.pkgs.papermc-1_18_x

    ]) ++ (let
      nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@"
      '';
    in [ nvidia-offload ]);

  # Custom Desktop Shortcuts
  home.file = {
    # ".local/share/icons/wechat_devtools.png".source =
    #   ./shortcuts/wechat-devtools.png;
    # ".local/share/applications/io.github.msojocs.wechat_devtools.desktop".source =
    #   ./shortcuts/io.github.msojocs.wechat_devtools.desktop;
    # ".local/share/icons/Adobe_Photoshop_CS6.png".source =
    #   ./shortcuts/Adobe_Photoshop_CS6.png;
    # ".local/share/applications/Adobe_Photoshop_CS6.desktop".source =
    #   ./shortcuts/Adobe_Photoshop_CS6.desktop;
    # ".local/share/icons/Adobe_Illustrator_CS6.png".source =
    #   ./shortcuts/Adobe_Illustrator_CS6.png;
    # ".local/share/applications/Adobe_Illustrator_CS6.desktop".source =
    #   ./shortcuts/Adobe_Illustrator_CS6.desktop;

  };
  # home.file.".local/share/applications/vim.desktop".source = ./shortcuts/vim.desktop;
  # home.file.".local/share/applications/code_ime.desktop".source = ./shortcuts/code_ime.desktop;

  services = {
    kdeconnect.enable = true;
    kdeconnect.indicator = true;
  };
}
