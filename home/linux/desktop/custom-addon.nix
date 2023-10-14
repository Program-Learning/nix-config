{ config, pkgs, pkgs-unstable, nur-ryan4yin, nur-program-learning
, nur-linyinfeng, nur-xddxdd, nur-AtaraxiaSjel, nur-arti5an, ... }: {
  home.packages = (with pkgs;
  # nixpkgs here
    [
      bluetooth_battery
      nftables
      cachix
      weston
      libsForQt5.qtstyleplugin-kvantum
      gnome.adwaita-icon-theme
      go-musicfox
      mpvpaper
      # --nvidia cuda
      cudatoolkit

      # bilibili
      yutto

      konsole
      powerdevil

      # --android
      gnome.gnome-boxes
      gnirehtet
      libmtp
      adb-sync
      abootimg
      android-studio
      genymotion
      # --payload-dumper
      payload-dumper-go

      # --java ide
      # jetbrains.idea-ultimate
      jetbrains.idea-community
      eclipses.eclipse-sdk

      # --mc
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
      playonlinux
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
      libsForQt5.qt5ct
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
      bluetooth_battery
      sysfsutils
      jq
      # wlroots
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
      #clang15Stdenv
      #pkgsLLVM.crossLibcStdenv
      # clang-tools
      glibc
      libcxx
      zlib
      ninja
    ])
  # nixpkgs-unstable
    ++ (with pkgs-unstable; [ fastfetch hmcl rustdesk OVMFFull.fd ])
    # nur packages here
    ++ (with pkgs.nur.repos; [
      # YisuiMilena.hmcl-bin
      nur-linyinfeng.packages.${pkgs.system}.wemeet
      nur-linyinfeng.packages.${pkgs.system}.icalingua-plus-plus
      nur-linyinfeng.packages.${pkgs.system}.matrix-wechat
      nur-xddxdd.packages.${pkgs.system}.wechat-uos
      nur-xddxdd.packages.${pkgs.system}.dingtalk
      # nur-xddxdd.packages.${pkgs.system}.bilibili
      nur-xddxdd.packages.${pkgs.system}.onepush
      nur-xddxdd.packages.${pkgs.system}.grasscutter
      nur-AtaraxiaSjel.packages.${pkgs.system}.waydroid-script
      nur-arti5an.packages.${pkgs.system}.mount-zip
      nur-program-learning.packages.${pkgs.system}.qtscrcpy
      # nur-program-learning.packages.${pkgs.system}.waybar-bluetooth_battery_parse
      # aleksana.go-musicfox
      # aleksana.fastfetch
      # alexnortung.pkgs.papermc-1_18_x

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
