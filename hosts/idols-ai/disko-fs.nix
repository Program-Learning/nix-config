# Disko layout for idols-ai on nvme1n1 (target disk after migration).
# Same structure as current nvme0n1: ESP + LUKS + btrfs with ephemeral root (tmpfs).
#
# Destroy, format & mount (wipes disk; from nixos-installer: cd nix-config/nixos-installer):
#   nix run github:nix-community/disko -- --mode destroy,format,mount ../hosts/idols-ai/disko-fs.nix
# Mount only (after first format):
#   nix run github:nix-community/disko -- --mode mount ../hosts/idols-ai/disko-fs.nix
#
# Override device when installing, e.g.:
#   nixos-install --flake .#ai --option disko.devices.disk.nixos-ai.device /dev/nvme1n1
{
  # Ephemeral root; preservation mounts /persistent for state.
  fileSystems."/persistent".neededForBoot = true;

  disko.devices = {
    # Ephemeral root; relatime and mode=755 so systemd does not set 777.
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=4G"
        "relatime" # Update inode access times relative to modify/change time
        "mode=755"
      ];
    };

    disk.nixos-ai = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-ZHITAI_TiPlus7100_2TB_ZTA42T0BA233530VAL";
      content = {
        type = "gpt";
        partitions = {
          # EFI system partition; must stay unencrypted for UEFI to load the bootloader.
          ESP = {
            priority = 1;
            name = "ESP";
            start = "1M";
            end = "600M";
            type = "EF00"; # EF00 = ESP in GPT
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0177" # File mask: 777-177=600 (owner rw-, group/others ---)
                "dmask=0077" # Directory mask: 777-077=700 (owner rwx, group/others ---)
                "noexec,nosuid,nodev" # Security: no execution, ignore setuid, no device nodes
              ];
            };
          };
          # Root partition: LUKS encrypted, then btrfs with subvolumes.
          root = {
            size = "100%";
            content = {
              type = "luks";
              name = "nixos-luks"; # Mapper name; match boot.initrd.luks
              settings = {
                allowDiscards = true; # TRIM for SSDs; slightly less secure, better performance
              };
              # Add boot.initrd.luks.devices so initrd prompts for passphrase at boot
              initrdUnlock = true;
              # cryptsetup luksFormat options
              extraFormatArgs = [
                "--type luks2"
                "--cipher aes-xts-plain64"
                "--hash sha512"
                "--iter-time 5000"
                "--key-size 256"
                "--pbkdf argon2id"
                "--use-random" # Block until enough entropy from /dev/random
              ];
              extraOpenArgs = [
                "--timeout 10"
              ];
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Force overwrite if filesystem already exists
                subvolumes = {
                  # Top-level subvolume (id 5); used for btrfs send/receive and snapshots
                  "/" = {
                    mountpoint = "/btr_pool";
                    mountOptions = [ "subvolid=5" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress-force=zstd:1" # Save space and reduce I/O on SSD
                      "noatime"
                    ];
                  };
                  "@guix" = {
                    mountpoint = "/gnu";
                    mountOptions = [
                      "compress-force=zstd:1"
                      "noatime"
                    ];
                  };
                  "@persistent" = {
                    mountpoint = "/persistent";
                    mountOptions = [
                      "compress-force=zstd:1"
                    ];
                  };
                  "@snapshots" = {
                    mountpoint = "/snapshots";
                    mountOptions = [
                      "compress-force=zstd:1"
                    ];
                  };
                  "@tmp" = {
                    mountpoint = "/tmp";
                    mountOptions = [
                      "compress-force=zstd:1"
                    ];
                  };
                  # Swap subvolume read-only; disko creates swapfile and adds swapDevices
                  "@swap" = {
                    mountpoint = "/swap";
                    swap.swapfile.size = "20G";
                  };
                  # "root" = {
                  #   mountpoint = "/"; # Mounted by initrd; not used directly by systemd
                  #   mountOptions = [ "subvol=root" ]; # Subvolume for root filesystem; used by initrd
                  # };
                };
              };
            };
          };
        };
      };
    };
  };
  imports = [
    ./impermanence_addon.nix
  ];
  modules.desktop.impermanence-rootfs.enable = true;
  modules.desktop.impermanence-rootfs.fsType = "btrfs";
  # modules.desktop.impermanence-rootfs.btrfsBlockDevice = "/dev/disk/by-uuid/17df699e-6502-4205-955f-c456eb378d48";
  modules.desktop.impermanence-rootfs.btrfsBlockDevice = "/dev/mapper/nixos-luks";
  modules.desktop.impermanence-rootfs.retentionPeriod = 7;
  modules.desktop.impermanence-rootfs.preBackupCommand = ''
    [ -d /btrfs_tmp/root/etc/agenix ] && rm -rf /btrfs_tmp/root/etc/agenix || true
  '';
}
