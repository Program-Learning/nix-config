{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  nur-ryan4yin,
  nur-program-learning,
  nur-linyinfeng,
  nur-xddxdd,
  nur-AtaraxiaSjel,
  nur-arti5an,
  aagl,
  nixpkgs-23_05,
  ...
}: {
  nix.settings.substituters = ["https://mirror.sjtu.edu.cn/nix-channels/store" "https://mirrors.ustc.edu.cn/nix-channels/store"];
  home.packages =
    (with pkgs;
      # nixpkgs here
        [
          patchelf
          glib
          trickle
          # use this to pop a input window
          gnome.zenity
          jansson
          nftables
          cachix
          weston
          libsForQt5.qtstyleplugin-kvantum
          gnome.adwaita-icon-theme

          intel-gpu-tools
          # --nvidia cuda
          cudatoolkit

          # Bilibili video download
          pkgs-stable.yutto

          konsole
          powerdevil

          # --java ide
          # jetbrains.idea-ultimate
          jetbrains.idea-community
          eclipses.eclipse-sdk

          warp
          cloudflare-warp

          glib
          calcurse

          # --vim-like browser
          # vimb

          # --agent
          clash-verge
          sing-box

          # --Office
          onlyoffice-bin
          libreoffice
          mdp
          slides
          wpsoffice # unfree

          # --note
          anytype

          # --math software
          geogebra6

          # --achieve/file managers
          xarchiver
          mate.engrampa
          gnome.nautilus
          nautilus-open-any-terminal
          gnome.file-roller
          ark
          dolphin
          ranger

          # --wine
          protonup-qt
          wine-staging
          # wine64Packages.stagingFull
          # winePackages.stagingFull
          winetricks
          onscripter-en
          playonlinux
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
          novnc

          # dunst
          # pipewire
          wireplumber
          # tofi
          polkit-kde-agent
          # eww-wayland
          # rofi-wayland
          # qt6.qtwayland
          # wayland
          # wayland-scanner
          # wayland-utils
          # egl-wayland
          # wayland-protocols
          # glfw-wayland
          # libsForQt5.qt5.qtwayland
          xdg-desktop-portal-hyprland
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
          # dash
          unrar-wrapper
          # python2Full
          inotify-tools
          vmware-workstation

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
        nur-linyinfeng.packages.${pkgs.system}.wemeet
        nur-linyinfeng.packages.${pkgs.system}.icalingua-plus-plus
        nur-linyinfeng.packages.${pkgs.system}.matrix-wechat
        nur-xddxdd.packages.${pkgs.system}.wechat-uos
        nur-xddxdd.packages.${pkgs.system}.dingtalk
        nur-xddxdd.packages.${pkgs.system}.baidunetdisk
        nur-xddxdd.packages.${pkgs.system}.baidupcs-go
        nur-xddxdd.packages.${pkgs.system}.bilibili
        nur-xddxdd.packages.${pkgs.system}.onepush
        nur-AtaraxiaSjel.packages.${pkgs.system}.waydroid-script
        nur-arti5an.packages.${pkgs.system}.mount-zip
        nur-program-learning.packages.${pkgs.system}.watt-toolkit_2
        nur-program-learning.packages.${pkgs.system}.AppimageLauncher_deb
        nur-program-learning.packages.${pkgs.system}.XiaoMiToolV2
        # nur-program-learning.packages.${pkgs.system}.CrossOver
        # nur-program-learning.packages.${pkgs.system}.waybar-bluetooth_battery_parse
        # aleksana.go-musicfox
        # aleksana.fastfetch
        # alexnortung.pkgs.papermc-1_18_x
      ]
    )
    # ++ (with nixpkgs-23_05; [sqliteman])
    # use hardware.nvidia.prime.offload.enableOffloadCmd instead!
    #++ (let
    #  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    #    export __NV_PRIME_RENDER_OFFLOAD=1
    #    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    #    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    #    export __VK_LAYER_NV_optimus=NVIDIA_only
    #    exec "$@"
    #  '';
    #in [nvidia-offload])
    ;

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
  # home.file.".local/share/applications/code_no_gpu.desktop".source = ./shortcuts/code_no_gpu.desktop;

  services = {
    kdeconnect.enable = true;
    kdeconnect.indicator = true;
  };
}
