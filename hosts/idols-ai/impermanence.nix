{
  impermanence,
  pkgs,
  ...
}: {
  imports = [
    impermanence.nixosModules.impermanence
  ];

  environment.systemPackages = [
    # `sudo ncdu -x /`
    pkgs.ncdu
  ];

  # There are two ways to clear the root filesystem on every boot:
  ##  1. use tmpfs for /
  ##  2. (btrfs/zfs only)take a blank snapshot of the root filesystem and revert to it on every boot via:
  ##     boot.initrd.postDeviceCommands = ''
  ##       mkdir -p /run/mymount
  ##       mount -o subvol=/ /dev/disk/by-uuid/UUID /run/mymount
  ##       btrfs subvolume delete /run/mymount
  ##       btrfs subvolume snapshot / /run/mymount
  ##     '';
  #
  #  See also https://grahamc.com/blog/erase-your-darlings/

  # NOTE: impermanence only mounts the directory/file list below to /persistent
  # If the directory/file already exists in the root filesystem, you should
  # move those files/directories to /persistent first!
  environment.persistence."/persistent" = {
    # sets the mount option x-gvfs-hide on all the bind mounts
    # to hide them from the file manager
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/etc/nix/inputs"
      "/etc/secureboot" # lanzaboote - secure boot
      # my secrets
      "/etc/agenix/"

      "/var/log"
      "/var/lib"

      # daed
      "/etc/daed/"

      # created by modules/nixos/misc/fhs-fonts.nix
      # for flatpak apps
      # "/usr/share/fonts"
      # "/usr/share/icons"
    ];
    files = [
      "/etc/machine-id"
    ];

    # the following directories will be passed to /persistent/home/$USER
    users.nixos = {
      directories = [
        "codes"
        "nix-config"
        "tmp"

        "Desktop"
        ".gnome"
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "Templates"

        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }

        # misc
        ".config/pulse"
        ".pki"
        ".steam" # steam games
        ".wine"
        ".minecraft"
        "GOG Games"

        "Apps" # some apps temporarily store at here

        ".config/Ryujinx"
        ".config/yuzu"
        ".config/suyu"
        ".config/lutris"
        ".config/gnome-boxes"
        "Android"
        ".android"
        ".config/.android"
        "workspace"
        ".Genymobile"
        "AndroidStudioProjects"
        "IdeaProjects"

        # cloud native
        {
          # pulumi - infrastructure as code
          directory = ".pulumi";
          mode = "0700";
        }
        {
          directory = ".aws";
          mode = "0700";
        }
        {
          directory = ".docker";
          mode = "0700";
        }
        {
          directory = ".kube";
          mode = "0700";
        }

        ".tldr"

        # remote desktop
        ".config/remmina"
        ".config/freerdp"

        # doom-emacs
        ".config/emacs"
        "org" #  org files

        # vscode
        ".vscode"
        ".vscode-insiders"
        ".config/Code"
        ".config/vscode-sqltools"
        ".config/Code - Insiders"

        # zed
        ".config/zed"

        # browsers
        ".mozilla"
        ".config/google-chrome"
        ".config/google-chrome-unstable"
        ".config/microsoft-edge"

        # neovim / remmina / flatpak / zed ...
        ".local/share"
        ".local/state"

        # language package managers
        ".npm"
        ".conda" # generated by `conda-shell`
        "go"
        ".cargo" # rust
        ".m2" # maven
        ".gradle" # gradle

        # neovim plugins(wakatime & copilot)
        ".wakatime"
        ".config/github-copilot"

        # others
        ".config/blender"

        # clash
        ".config/clash"
        ".config/clash-verge"
        ".config/clash-nyanpasu"
        # v2ray
        ".config/qv2ray"
        ".config/nekoray"

        # test niri
        ".config/niri"

        # ai related file dirs
        "invokeai"
        ".textgen"
        ".config/LaphaeLaicmd"
        ".config/aichat"
        ".config/open-webui"
        ".ollama"
        ".cache/huggingface"
        ".lingma"

        ".vmware"
        "VirtualBox VMs"
        ".config/VirtualBox"
        ".config/lxc"
        ".config/libvirt"

        ".config/.cpolar"
        ".config/aDrive"
        ".config/baidunetdisk"
        ".config/wechat-devtools"
        ".config/JetBrains"
        ".config/io.hoppscotch.desktop"
        ".config/ncmpcpp"
        ".config/uGet"
        ".config/Motrix"
        ".config/sunshine"
        ".config/QQ"
        ".config/icalingua"
        ".config/MuseScore"
        ".config/ghc"
        ".config/Kingsoft"
        ".config/libreoffice"
        ".config/onlyoffice"
        ".config/Genymobile"
        ".config/gh"
        ".config/go-musicfox"
        ".config/GIMP"
        ".config/anytype"
        ".config/obs-studio"
        ".config/kdeconnect"
        ".config/DingTalk"
        ".config/bilibili"
        ".config/Google"
        ".config/Moonlight Game Streaming Project"

        # kde related
        ".config/kdedefaults"

        # Trash Bin(not work yet)
        # https://github.com/nix-community/impermanence/issues/147
        # we already have .local/share
        # ".local/share/Trash"

        ".cache/tlrc"

        # nvfetcher
        "_sources"
      ];
      files = [
        ".wakatime.cfg"
        ".config/nushell/history.txt"
        ".condarc"

        # nvfetcher
        "nvfetcher.toml"
      ];
    };
  };
}
