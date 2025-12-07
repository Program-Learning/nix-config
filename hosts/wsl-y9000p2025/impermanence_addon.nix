#TODO: refactor
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.rootfs;
in
{
  options.modules.desktop.rootfs = {
    fsType = mkOption {
      type = types.enum [
        "tmpfs"
        "btrfs"
      ];
      default = "tmpfs";
      description = "The filesystem type for the root filesystem.";
    };
    btrfsBlockDevice = mkOption {
      type = types.str;
      default = "";
      description = "The block device for btrfs root filesystem.";
    };
    retentionPeriod = mkOption {
      type = types.int;
      default = 30;
      description = "Retention period for old root subvolumes (in days).";
    };
    PreBackupCommand = mkOption {
      type = types.str;
      default = "";
      description = "The Command before Backup start";
    };
    PostBackupCommand = mkOption {
      type = types.str;
      default = "";
      description = "The Command after Backup finished";
    };
  };

  config = {
    assertions = [
      # Not strictly required but probably a good assertion to have
      {
        assertion = cfg.fsType == "btrfs" && cfg.btrfsBlockDevice == "";
        message = "cfg.fsType == btrfs requires cfg.btrfsBlockDevice not empty";
      }
    ];
  }
  // mkMerge [
    (mkIf (cfg.fsType == "tmpfs") {
      # equal to `mount -t tmpfs tmpfs /`
      fileSystems."/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        # set mode to 755, otherwise systemd will set it to 777, which cause problems.
        # relatime: Update inode access times relative to modify or change time.
        options = [
          "relatime"
          "mode=755"
        ];
      };
    })
    (mkIf (cfg.fsType == "btrfs" && cfg.btrfsBlockDevice != "") {
      fileSystems."/" = {
        device = cfg.btrfsBlockDevice;
        fsType = "btrfs";
        options = [ "subvol=root" ];
      };
      boot.initrd.postDeviceCommands = lib.mkAfter ''
        mkdir -p /btrfs_tmp
        mount ${cfg.btrfsBlockDevice} /btrfs_tmp
        if [ -e /btrfs_tmp/root ]; then
            ${cfg.PreBackupCommand}
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
            ${cfg.PostBackupCommand}
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +${toString cfg.retentionPeriod}); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
    })
    # You can add more filesystem types here as needed
  ];
}
