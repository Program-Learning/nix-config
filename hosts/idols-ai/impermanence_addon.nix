#TODO: refactor
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.impermanence-rootfs;
  diskoEnabled = config.disko ? devices;
in
{
  options.modules.desktop.impermanence-rootfs = {
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
    preBackupCommand = mkOption {
      type = types.str;
      default = "";
      description = "The Command before Backup start";
    };
    postBackupCommand = mkOption {
      type = types.str;
      default = "";
      description = "The Command after Backup finished";
    };
    wants = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional systemd units to want for the impermanence-setup service.";
    };
    afters = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional systemd units to order after for the impermanence-setup service.";
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.fsType == "btrfs" -> cfg.btrfsBlockDevice != "";
        message = "fsType=btrfs requires btrfsBlockDevice to be set";
      }
    ];
  }
  // mkMerge [
    # TMPFS SUPPORT
    (mkIf (cfg.fsType == "tmpfs" && !diskoEnabled) {
      fileSystems."/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "relatime"
          "mode=755"
        ];
      };
    })

    (mkIf (cfg.fsType == "tmpfs" && diskoEnabled) {
      disko.devices.nodev."/" = lib.mkForce {
        fsType = "tmpfs";
        mountOptions = [
          "relatime" # Update inode access times relative to modify/change time
          "mode=755"
        ];
      };
    })

    # BTRFS SUPPORT
    (mkIf (cfg.fsType == "btrfs" && !diskoEnabled) {
      fileSystems."/" = lib.mkForce {
        device = cfg.btrfsBlockDevice;
        fsType = "btrfs";
        options = [ "subvol=root" ];
      };
    })

    (mkIf (cfg.fsType == "btrfs" && diskoEnabled) {
      # disko.devices.nodev."/" = lib.mkForce {
      #   fsType = "btrfs";
      #   mountOptions = [ "subvol=root" ];
      # };
      fileSystems."/" = lib.mkForce {
        device = cfg.btrfsBlockDevice;
        fsType = "btrfs";
        options = [ "subvol=root" ];
      };
    })

    (mkIf (cfg.fsType == "btrfs" && config.boot.initrd.systemd.enable) {
      boot.initrd.systemd.services.impermanence-setup = lib.mkForce {
        description = "Impermanence setup for btrfs root subvolume";
        wantedBy = [ "initrd.target" ];
        before = [ "initrd.target" ];
        # before = [ "sysroot.mount" ];
        # unitConfig.DefaultDependencies = "no";
        # wants = cfg.wants;
        # afters = cfg.afters;
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /btrfs_tmp
          mount -t btrfs ${cfg.btrfsBlockDevice} /btrfs_tmp
          if [ -e /btrfs_tmp/root ]; then
              ${cfg.preBackupCommand}
              mkdir -p /btrfs_tmp/old_roots
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
              ${cfg.postBackupCommand}
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
      };
    })
    (mkIf (cfg.fsType == "btrfs" && !config.boot.initrd.systemd.enable) {
      boot.initrd.postDeviceCommands = (
        lib.mkAfter ''
          mkdir -p /btrfs_tmp
          mount -t btrfs ${cfg.btrfsBlockDevice} /btrfs_tmp
          if [ -e /btrfs_tmp/root ]; then
              ${cfg.preBackupCommand}
              mkdir -p /btrfs_tmp/old_roots
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
              ${cfg.postBackupCommand}
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
        ''
      );
    })
  ];
}
