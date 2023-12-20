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
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
  boot.extraModulePackages = [];

  # Enable binfmt emulation of aarch64-linux, this is required for cross compilation.
  boot.binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];
  # supported fil systems, so we can mount any removable disks with these filesystems
  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    "ntfs"
    "fat"
    "vfat"
    "cifs" # mount windows share
  ];

  boot.initrd = {
    # unlocked luks devices via a keyfile or prompt a passphrase.
    luks.devices."crypted-nixos" = {
      device = "/dev/nvme0n1p2";
      # the keyfile(or device partition) that should be used as the decryption key for the encrypted device.
      # if not specified, you will be prompted for a passphrase instead.
      #keyFile = "/root-part.key";

      # whether to allow TRIM requests to the underlying device.
      # it's less secure, but faster.
      allowDiscards = true;
    };
  };

  # equal to `mount -t tmpfs tmpfs /`
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    # set mode to 755, otherwise systemd will set it to 777, which cause problems.
    options = ["relatime" "mode=755"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/1167076c-dee1-486c-83c1-4b1af37555cd";
    fsType = "btrfs";
    options = ["subvol=@nix" "noatime" "compress-force=zstd:1"];
  };

  fileSystems."/persistent" = {
    device = "/dev/disk/by-uuid/1167076c-dee1-486c-83c1-4b1af37555cd";
    fsType = "btrfs";
    options = ["subvol=@persistent" "compress-force=zstd:1"];
    # impermanence's data is required for booting.
    neededForBoot = true;
  };

  fileSystems."/snapshots" = {
    device = "/dev/disk/by-uuid/1167076c-dee1-486c-83c1-4b1af37555cd";
    fsType = "btrfs";
    options = ["subvol=@snapshots" "compress-force=zstd:1"];
  };

  # mount swap subvolume in readonly mode.
  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/1167076c-dee1-486c-83c1-4b1af37555cd";
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
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/swap/swapfile";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
