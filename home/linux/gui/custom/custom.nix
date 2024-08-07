{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  nur-ryan4yin,
  nur-program-learning,
  nur-linyinfeng,
  nur-DataEraserC,
  nur-AtaraxiaSjel,
  hyprland-plugins,
  hyprland,
  ...
}: {
  home.packages =
    (with pkgs;
      # nixpkgs here
        [
          mount-zip
          # AutoClick tool
          xdotool
          dotool
          ydotool
          wlrctl
          wtype

          patchelf
          glib
          trickle
          # use this to pop a input window
          zenity
          jansson
          nftables
          cachix
          weston
          libsForQt5.qtstyleplugin-kvantum
          adwaita-icon-theme

          intel-gpu-tools
          # --nvidia cuda
          # cudatoolkit

          # Bilibili video download
          pkgs-stable.yutto

          konsole
          powerdevil

          # --java ide
          # jetbrains.idea-ultimate
          jetbrains.idea-community
          eclipses.eclipse-sdk

          cloudflare-warp
          wgcf

          glib
          calcurse

          # --vim-like browser
          # vimb

          # --agent
          # pkgs-unstable.clash-verge-rev
          # pkgs-unstable.clash-nyanpasu
          # nekoray_patched
          nekoray
          sing-box

          # --Office
          onlyoffice-bin
          libreoffice
          mdp
          slides
          wpsoffice-cn # unfree

          # --note
          anytype

          # --math software
          # geogebra6

          # --achieve/file managers
          xarchiver
          mate.engrampa
          nautilus
          nautilus-open-any-terminal
          file-roller
          ark
          dolphin
          ranger

          qrencode

          # --wine
          protonup-qt
          # wine-staging
          wine64Packages.stagingFull
          # winePackages.stagingFull
          winetricks
          onscripter-en
          pkgs-stable.playonlinux
          bottles
          # bottles-unwrapped
          lutris
          # lutris-unwrapped

          # --remote control
          # sunshine
          # moonlight-embedded
          # turbovnc
          xrdp
          libvncserver
          gnome.gnome-remote-desktop
          gnome.gnome-clocks

          # dunst
          # pipewire
          wireplumber
          # tofi
          polkit-kde-agent
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
          linuxKernel.packages.linux_6_1.v4l2loopback
          libsForQt5.polkit-kde-agent
          # kitty-themes

          adwaita-qt
          adwaita-qt6
          lxde.lxsession # lxpolkit
          # polkit_gnome
          # deepin.dde-polkit-agent
          swappy
          bluez
          sysfsutils
          # jq
          # wlroots
          # catppuccin-kvantum
          # htop
          vim # file editor
          # postman
          artha
          iw
          file
          coreutils
          openssl
          gitRepo
          fuse
          ntfs3g
          jadx
          meld
          darling-dmg
          # darling
          # dash
          unrar-wrapper
          # python2Full
          inotify-tools
          # vmware-workstation

          # vaapi
          gst_all_1.gst-vaapi
          # sshfs
          sftpman
          # edge browser
          microsoft-edge
          # sql
          mysql80

          # pkg required by nix-shell
          pkg-config
          ncurses
          # ncurses6
          # ncurses5
          pkgsCross.aarch64-multiplatform.stdenv.cc
          pkgsCross.arm-embedded.stdenv.cc
          #clang15Stdenv
          #pkgsLLVM.crossLibcStdenv
          # clang-tools
          # glibc
          libcxx
          zlib
          ninja
        ])
    # nixpkgs-unstable
    ++ (with pkgs-unstable; [
      OVMFFull.fd
    ])
    # nur packages here
    ++ (
      # with pkgs.nur.repos;
      [
        # YisuiMilena.hmcl-bin
        nur-linyinfeng.packages.${pkgs.system}.matrix-wechat
        nur-DataEraserC.packages.${pkgs.system}.baidunetdisk
        nur-DataEraserC.packages.${pkgs.system}.baidupcs-go
        nur-DataEraserC.packages.${pkgs.system}.bilibili
        nur-DataEraserC.packages.${pkgs.system}.onepush
        nur-AtaraxiaSjel.packages.${pkgs.system}.waydroid-script
        nur-DataEraserC.packages.${pkgs.system}.watt-toolkit_2
        nur-DataEraserC.packages.${pkgs.system}.AppimageLauncher_deb
        nur-DataEraserC.packages.${pkgs.system}.XiaoMiToolV2
        # nur-DataEraserC.packages.${pkgs.system}.CrossOver
        # nur-DataEraserC.packages.${pkgs.system}.waybar-bluetooth_battery_parse
        # alexnortung.pkgs.papermc-1_18_x
      ]
    );

  services = {
    kdeconnect.enable = true;
    kdeconnect.indicator = true;
  };
}
