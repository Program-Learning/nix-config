{
  preservation,
  pkgs,
  myvars,
  ...
}:
let
  inherit (myvars) username;
  makeDirRW = dir: {
    directory = dir;
    configureParent = true;
  };
in
{
  imports = [
    preservation.nixosModules.default
  ];

  preservation.enable = true;
  # pverservation required initrd using systemd.
  boot.initrd.systemd.enable = true;

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

  # NOTE: preservation only mounts the directory/file list below to /persistent
  # If the directory/file already exists in the root filesystem you should
  # move those files/directories to /persistent first!
  preservation.preserveAt."/persistent" = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/etc/nix/inputs"
      "/etc/secureboot" # lanzaboote - secure boot
      # my secrets
      "/etc/agenix/"

      "/var/log"

      # system-core
      "/var/lib/nixos"
      "/var/lib/systemd"
      {
        directory = "/var/lib/private";
        mode = "0700";
      }

      # containers
      # "/var/lib/docker"
      "/var/lib/cni"
      "/var/lib/containers"

      # other data
      "/var/lib/flatpak"

      # virtualisation
      "/var/lib/libvirt"
      "/var/lib/lxc"
      "/var/lib/lxd"
      "/var/lib/qemu"
      # "/var/lib/waydroid"

      # network
      "/var/lib/tailscale"
      "/var/lib/bluetooth"
      "/var/lib/NetworkManager"
      "/var/lib/iwd"

      # Mayuri spec
      # daed
      "/etc/daed/"

      # ccache
      "/var/cache/ccache"

      # for android sign
      # TODO: move to agenix/sop
      "/etc/secrets/android-keys"
    ];
    files = [
      # auto-generated machine ID
      {
        file = "/etc/machine-id";
        inInitrd = true;
      }
    ];

    # the following directories will be passed to /persistent/home/$USER
    users.${username} = {
      commonMountOptions = [
        "x-gvfs-hide"
      ];
      directories = [
        # ======================================
        # XDG Directories
        # ======================================

        (makeDirRW "Desktop")
        (makeDirRW ".gnome")
        (makeDirRW "Downloads")
        (makeDirRW "Music")
        (makeDirRW "Pictures")
        (makeDirRW "Documents")
        (makeDirRW "Videos")
        (makeDirRW "Templates")

        # ======================================
        # Codes / Work / Playground
        # ======================================
        "codes" # for personal code
        "work" # for work contains a .gitconfig with my work email.
        "nix-config"
        "tmp"

        # ======================================
        # Nix / Home Manager Profiles
        # ======================================

        ".local/state/home-manager"
        ".local/state/nix/profiles"
        ".local/share/nix"

        # ======================================
        # IDE / Editors
        # ======================================

        # neovim plugins(wakatime & copilot)
        ".wakatime"
        ".config/github-copilot"

        # vscode
        ".vscode"
        ".config/Code"
        ".vscode-insiders"
        ".config/Code - Insiders"
        ".config/vscode-sqltools"

        # cursor ai editor
        ".cursor"
        ".config/Cursor"

        # zed editor
        ".config/zed"
        ".local/share/zed"

        # ai agents
        ".claude"
        ".gemini"

        # nvim
        ".local/share/nvim"
        ".local/state/nvim"

        # doom-emacs
        # "org" # org files
        # ".config/emacs"
        # ".local/share/doom"
        # ".local/share/emacs"

        # Joplin
        ".config/joplin" # tui client
        ".config/Joplin" # joplin-desktop

        # ".local/share/jupyter"

        # ======================================
        # Cloud Native
        # ======================================
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
          directory = ".aliyun";
          mode = "0700";
        }
        {
          directory = ".config/gcloud";
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
        ".terraform.d/plugin-cache" # terraform's plugin cache

        # ======================================
        # language package managers
        # ======================================
        ".npm" # typsescript/javascript
        "go"
        ".cargo" # rust
        ".m2" # java maven
        ".gradle" # java gradle
        ".conda" # python generated by `conda-shell`
        # python pipx
        ".local/pipx"
        ".local/bin"
        # python uv
        ".local/share/uv"
        ".cache/uv"

        # ======================================
        # Security
        # ======================================

        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".pki";
          mode = "0700";
        }

        ".local/share/password-store"
        # gnmome keyrings
        ".local/share/keyrings"

        # ======================================
        # Games / Media
        # ======================================

        ".steam"
        ".config/blender"
        ".config/LDtk"

        ".local/share/Steam"
        ".local/share/PrismLauncher"

        ".local/share/tiled"
        ".local/share/GOG.com"
        ".local/share/StardewValley"
        ".local/share/feral-interactive"

        # ======================================
        # Instant Messaging
        # ======================================
        ".config/QQ"

        ".local/share/TelegramDesktop"

        # ======================================
        # Meeting / Remote Desktop
        # ======================================
        ".config/remmina"
        ".config/freerdp"
        ".zoom"

        ".local/share/remmina"

        # ======================================
        # browsers
        # ======================================
        ".mozilla"
        ".config/google-chrome"
        ".cache/google-chrome"
        ".config/google-chrome-unstable"
        ".config/microsoft-edge"

        # ======================================
        # CLI data
        # ======================================
        ".local/share/atuin"
        ".local/share/zoxide"
        ".local/share/direnv"
        ".local/share/k9s"
        ".cache/tealdeer" # tldr

        # ======================================
        # Containers
        # ======================================
        ".local/share/containers"
        ".local/share/flatpak"
        # flatpak app's data
        ".var"

        # ======================================
        # Misc
        # ======================================

        # Audio
        ".config/pulse"
        ".local/state/wireplumber"

        # Digital Painting
        ".local/share/krita"

        # Mayuri Spec

        (makeDirRW ".wine")
        (makeDirRW ".minecraft")
        (makeDirRW "GOG Games")

        (makeDirRW "Apps") # some apps temporarily store at here

        (makeDirRW ".config/Ryujinx")
        (makeDirRW ".config/yuzu")
        (makeDirRW ".config/suyu")
        (makeDirRW ".config/lutris")
        (makeDirRW ".config/gnome-boxes")
        (makeDirRW "Android")
        (makeDirRW ".android")
        ".config/.android"
        (makeDirRW "workspace")
        (makeDirRW "eclipse-workspace")
        (makeDirRW ".Genymobile")
        (makeDirRW "AndroidStudioProjects")
        (makeDirRW "IdeaProjects")
        (makeDirRW ".jdks")

        # nix-index
        ".cache/nix-index"

        (makeDirRW ".tldr")

        # cisco packet tracer
        (makeDirRW "pt")

        # email clients profiles
        (makeDirRW ".thunderbird")

        # ServerBox
        ".config/ServerBox"

        (makeDirRW "BetterUniverse")

        # clash
        ".config/clash"
        ".config/clash-verge"
        ".config/clash-nyanpasu"
        ".config/mihomo-party"
        # v2ray
        ".config/qv2ray"
        ".config/nekoray"
        # gg
        ".config/gg"

        # test niri
        ".config/niri"

        # ai related file dirs
        (makeDirRW "invokeai")
        (makeDirRW ".textgen")
        ".config/LaphaeLaicmd"
        ".config/aichat"
        # NOTE: this can be remove bcs we use `services.ollama` which place files in `/var/lib/ollama` by default
        ".ollama"
        # NOTE: this can be remove bcs we use `services.open-webui` which place state files in `/var/lib/open-webui` by default
        ".config/open-webui"
        ".config/CherryStudio"
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

        # nvfetcher cache
        (makeDirRW "_sources")

        # Trash Bin
        (makeDirRW ".Trash-1000")
      ];
      files = [
        {
          file = ".wakatime.cfg";
          how = "symlink";
        }
        {
          file = ".config/zoomus.conf";
          how = "symlink";
        }
        {
          file = ".config/zoom.conf";
          how = "symlink";
        }
        {
          file = ".claude.json";
          how = "symlink";
        }
        {
          file = ".condarc";
          how = "symlink";
        }
        {
          file = "nvfetcher.toml";
          how = "symlink";
        }
      ];
    };
  };

  # Create some directories with custom permissions.
  #
  # In this configuration the path `/home/butz/.local` is not an immediate parent
  # of any persisted file so it would be created with the systemd-tmpfiles default
  # ownership `root:root` and mode `0755`. This would mean that the user `butz`
  # could not create other files or directories inside `/home/butz/.local`.
  #
  # Therefore systemd-tmpfiles is used to prepare such directories with
  # appropriate permissions.
  #
  # Note that immediate parent directories of persisted files can also be
  # configured with ownership and permissions from the `parent` settings if
  # `configureParent = true` is set for the file.
  systemd.tmpfiles.settings.preservation =
    let
      permission = {
        user = username;
        group = "users";
        mode = "0755";
      };
    in
    {
      "/home/${username}/.config".d = permission;
      "/home/${username}/.cache".d = permission;
      "/home/${username}/.local".d = permission;
      "/home/${username}/.local/share".d = permission;
      "/home/${username}/.local/state".d = permission;
      "/home/${username}/.local/state/nix".d = permission;
      "/home/${username}/.terraform.d".d = permission;
    };

  # systemd-machine-id-commit.service would fail but it is not relevant
  # in this specific setup for a persistent machine-id so we disable it
  #
  # see the firstboot example below for an alternative approach
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

  # let the service commit the transient ID to the persistent volume
  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persistent/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persistent"
    ];
  };
}
