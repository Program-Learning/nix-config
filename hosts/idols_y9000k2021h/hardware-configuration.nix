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
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.enable = true;

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [
    # kvm
    "kvm-intel"
    # Virtual Camera
    "v4l2loopback"
    # Virtual Microphone, built-in
    "snd-aloop"
    #"acpi_call"
  ];
  boot.extraModprobeConfig =
    # for intel cpu
    "options kvm_intel nested=1"
    + ''
      # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
      # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
      # https://github.com/umlaeute/v4l2loopback
      options v4l2loopback exclusive_caps=1 video_nr=9 card_label="Virtual Camera"
    '';
  boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback.out
    # config.boot.kernelPackages.acpi_call.out
    # config.boot.kernelPackages.v4l2loopback
  ];
  # clear /tmp on boot to get a stateless /tmp directory.
  boot.tmp.cleanOnBoot = true;

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
    "exfat"
    "cifs" # mount windows share
  ];

  #boot.initrd = {
  #  # unlocked luks devices via a keyfile or prompt a passphrase.
  #  luks.devices."crypted-nixos" = {
  #    # NOTE: DO NOT use device name here(like /dev/sda, /dev/nvme0n1p2, etc), use UUID instead.
  #    # https://github.com/ryan4yin/nix-config/issues/43
  #    device = "/dev/disk/by-uuid/a21ca82a-9ee6-4e5c-9d3f-a93e84e4e0f4";
  #    # the keyfile(or device partition) that should be used as the decryption key for the encrypted device.
  #    # if not specified, you will be prompted for a passphrase instead.
  #    #keyFile = "/root-part.key";

  #    # whether to allow TRIM requests to the underlying device.
  #    # it's less secure, but faster.
  #    allowDiscards = true;
  #  };
  #};

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7bd1f58c-482d-4c70-bba8-a3aa216eaef6";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/DBEB-5479";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/49e5a291-fc25-4d0e-84dd-9e30369a9a5f";}];

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
