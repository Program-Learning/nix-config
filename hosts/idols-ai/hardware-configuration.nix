# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Use the EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  # depending on how you configured your disk mounts, change this to /boot or /boot/efi.
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.systemd-boot.enable = true;

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  services.scx.enable = true;
  # boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_xanmod.override {
  #   structuredExtraConfig = with lib.kernel; {
  #     DMABUF_HEAPS = yes;
  #     DMABUF_HEAPS_SYSTEM = yes;
  #   };
  # });

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["uas" "usbcore" "usb_storage" "vfat" "nls_cp437" "nls_iso8859_1"];
  boot.kernelModules = [
    # kvm
    "kvm-amd" # kvm virtualization support
    "amdgpu"
    #"acpi_call"
    "usb_storage"
  ];
  boot.extraModprobeConfig = ''
    options iommu=pt
    options kvm_amd nested=1
    options bt_coex_active=0 swcrypto=1 11n_disable=8
    options kvm ignore_msrs=1 report_ignored_msrs=0
  '';
  boot.extraModulePackages = [
    # config.boot.kernelPackages.acpi_call.out
  ];
  # clear /tmp on boot to get a stateless /tmp directory.
  boot.tmp.cleanOnBoot = true;

  # Enable binfmt emulation of aarch64-linux, this is required for cross compilation.
  boot.binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];
  # supported file systems, so we can mount any removable disks with these filesystems
  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
  ];

  boot.initrd = {
    # postDeviceCommands = let
    #   PRIMARYUSBID = "D7AB-22CE";
    #   BACKUPUSBID = "12CE-A600";
    # in
    #   pkgs.lib.mkBefore ''
    #     mkdir -m 0755 -p /key
    #     sleep 2 # To make sure the usb key has been loaded
    #     mount -n -t vfat -o ro `findfs UUID=${PRIMARYUSBID}` /key || mount -n -t vfat -o ro `findfs UUID=${BACKUPUSBID}` /key
    #   '';
    # unlocked luks devices via a keyfile or prompt a passphrase.
    luks.devices."crypted-nixos" = {
      # NOTE: DO NOT use device name here(like /dev/sda, /dev/nvme0n1p2, etc), use UUID instead.
      # https://github.com/ryan4yin/nix-config/issues/43
      device = "/dev/disk/by-uuid/979348b2-fcc5-4db0-85df-69819a218470";
      # the keyfile(or device partition) that should be used as the decryption key for the encrypted device.
      # if not specified, you will be prompted for a passphrase instead.
      keyFile = "/key/luks/root-part.key";
      # preLVM = false; # If this is true the decryption is attempted before the postDeviceCommands can run

      # whether to allow TRIM requests to the underlying device.
      # it's less secure, but faster.
      allowDiscards = true;
      # Whether to bypass dm-crypt’s internal read and write workqueues.
      # Enabling this should improve performance on SSDs;
      # https://wiki.archlinux.org/index.php/Dm-crypt/Specialties#Disable_workqueue_for_increased_solid_state_drive_(SSD)_performance
      bypassWorkqueues = true;
      # fallbackToPassword = true;
      keyFileTimeout = 5;
      tryEmptyPassphrase = true;
    };
  };

  fileSystems."/btr_pool" = {
    device = "/dev/disk/by-uuid/17df699e-6502-4205-955f-c456eb378d48";
    fsType = "btrfs";
    # btrfs's top-level subvolume, internally has an id 5
    # we can access all other subvolumes from this subvolume.
    options = ["subvolid=5"];
  };

  modules.desktop.rootfs.fsType = "tmpfs";
  # modules.desktop.rootfs.btrfsBlockDevice = "/dev/disk/by-uuid/17df699e-6502-4205-955f-c456eb378d48";
  # modules.desktop.rootfs.retentionPeriod = 7;
  # modules.desktop.rootfs.PreBackupCommand = ''
  #   rm -rf /btrfs_tmp/root/etc/agenix
  # '';

  # disable here because it will become a cfg in my config
  # equal to `mount -t tmpfs tmpfs /`
  #fileSystems."/" = {
  #  device = "tmpfs";
  #  fsType = "tmpfs";
  #  # set mode to 755, otherwise systemd will set it to 777, which cause problems.
  #  # relatime: Update inode access times relative to modify or change time.
  #  options = ["relatime" "mode=755"];
  #};

  # fileSystems."/" = {
  #  device = "/dev/disk/by-uuid/17df699e-6502-4205-955f-c456eb378d48";
  #  fsType = "btrfs";
  #  options = ["subvol=root"];
  # };

  # boot.initrd.postDeviceCommands = lib.mkAfter ''
  #  mkdir /btrfs_tmp
  #  mount /dev/disk/by-uuid/17df699e-6502-4205-955f-c456eb378d48 /btrfs_tmp
  #  if [[ -e /btrfs_tmp/root ]]; then
  #      mkdir -p /btrfs_tmp/old_roots
  #      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
  #      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
  #   fi

  #   delete_subvolume_recursively() {
  #       IFS=$'\n'
  #       for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #           delete_subvolume_recursively "/btrfs_tmp/$i"
  #       done
  #       btrfs subvolume delete "$1"
  #   }

  #   for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
  #       delete_subvolume_recursively "$i"
  #   done

  #   btrfs subvolume create /btrfs_tmp/root
  #   umount /btrfs_tmp
  # '';

  fileSystems."/key" = {
    device = "/dev/disk/by-uuid/D7AB-22CE";
    fsType = "vfat";
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/17df699e-6502-4205-955f-c456eb378d48";
    fsType = "btrfs";
    options = ["subvol=@nix" "noatime" "compress-force=zstd:1"];
  };

  # for guix store, which use `/gnu/store` as its store directory.
  fileSystems."/gnu" = {
    device = "/dev/disk/by-uuid/17df699e-6502-4205-955f-c456eb378d48";
    fsType = "btrfs";
    options = ["subvol=@guix" "noatime" "compress-force=zstd:1"];
  };

  fileSystems."/persistent" = {
    device = "/dev/disk/by-uuid/17df699e-6502-4205-955f-c456eb378d48";
    fsType = "btrfs";
    options = ["subvol=@persistent" "compress-force=zstd:1"];
    # preservation's data is required for booting.
    neededForBoot = true;
  };

  fileSystems."/snapshots" = {
    device = "/dev/disk/by-uuid/17df699e-6502-4205-955f-c456eb378d48";
    fsType = "btrfs";
    options = ["subvol=@snapshots" "compress-force=zstd:1"];
  };

  fileSystems."/tmp" = {
    device = "/dev/disk/by-uuid/17df699e-6502-4205-955f-c456eb378d48";
    fsType = "btrfs";
    options = ["subvol=@tmp" "compress-force=zstd:1"];
  };

  # mount swap subvolume in readonly mode.
  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/17df699e-6502-4205-955f-c456eb378d48";
    fsType = "btrfs";
    options = ["subvol=@swap" "ro"];
  };

  # remount swapfile in read-write mode
  fileSystems."/swap/swapfile" = {
    # the swapfile is located in /swap subvolume, so we need to mount /swap first.
    depends = ["/swap"];

    device = "/swap/swapfile";
    fsType = "none";
    options = ["bind" "rw"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F91B-B32A";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8192;
    }
  ];

  features.lenovo-legion = {
    enable = true;
    enhanceMode = true;
    installKernelModule = false;
  };
  features.intel-gpu-tools = {
    enable = false;
    enhanceMode = true;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.kernelParams = [
    "amd_iommu=on" # or "intel_iommu=on"
  ];
}
