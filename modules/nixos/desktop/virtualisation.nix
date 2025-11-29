{
  pkgs,
  pkgs-latest,
  nur-ataraxiasjel,
  winboat,
  # nur-ataraxiasjel,
  ...
}:
{
  ###################################################################################
  #
  #  Virtualisation - Libvirt(QEMU/KVM) / Docker / LXD / WayDroid
  #
  ###################################################################################

  # Enable nested virtualization, required by security containers and nested vm.
  # This should be set per host in /hosts, not here.
  #
  ## For AMD CPU, add "kvm-amd" to kernelModules.
  # boot.kernelModules = ["kvm-amd"];
  # boot.extraModprobeConfig = "options kvm_amd nested=1";  # for amd cpu
  #
  ## For Intel CPU, add "kvm-intel" to kernelModules.
  # boot.kernelModules = ["kvm-intel"];
  # boot.extraModprobeConfig = "options kvm_intel nested=1"; # for intel cpu

  boot.kernelModules = [ "vfio-pci" ];

  services.flatpak.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        # enables pulling using containerd, which supports restarting from a partial pull
        # https://docs.docker.com/storage/containerd/
        "features" = {
          "containerd-snapshotter" = true;
        };
      };

      # start dockerd on boot.
      # This is required for containers which are created with the `--restart=always` flag to work.
      enableOnBoot = true;
    };

    # Do not use "--restart=always" to create container, or shutdown/reboot will be slow
    # https://github.com/containers/podman/issues/15284
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = false;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      # Periodically prune Podman resources
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };

    # podman containers as systemd services(will break nixos's declare feat)
    oci-containers = {
      backend = "podman";
      # containers = {
      #   container-name = {
      #     image = "container-image";
      #     autoStart = true;
      #     ports = [ "127.0.0.1:1234:1234" ];
      #   };
      # };
    };

    # Usage: https://wiki.nixos.org/wiki/Waydroid
    waydroid.enable = true;

    libvirtd = {
      enable = true;
      # hanging this option to false may cause file permission issues for existing guests.
      # To fix these, manually change ownership of affected files in /var/lib/libvirt/qemu to qemu-libvirtd.
      qemu = {
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
    # lxd = {
    #   enable = false;
    #   ui.enable = true;
    # };
    incus = {
      enable = true;
      ui.enable = true;
    };
    virtualbox = {
      host = {
        enable = false;
        enableExtensionPack = true;
        enableKvm = true;
        addNetworkInterface = false;
        enableHardening = true;
        enableWebService = true;
        headless = false;
      };
    };
    vmware = {
      host = {
        # package = nur-program-learning.packages.${pkgs.system}.vmware-workstation.override {
        #   enableMacOSGuests = true;
        # };
        enable = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # This script is used to install the arm translation layer for waydroid
    # so that we can install arm apks on x86_64 waydroid
    #
    # https://github.com/casualsnek/waydroid_script
    # https://github.com/AtaraxiaSjel/nur/tree/master/pkgs/waydroid-script
    # https://wiki.archlinux.org/title/Waydroid#ARM_Apps_Incompatible
    nur-ataraxiasjel.packages.${pkgs.stdenv.hostPlatform.system}.waydroid-script

    # Need to add [File (in the menu bar) -> Add connection] when start for the first time
    virt-manager

    # QEMU/KVM(HostCpuOnly), provides:
    #   qemu-storage-daemon qemu-edid qemu-ga
    #   qemu-pr-helper qemu-nbd elf2dmp qemu-img qemu-io
    #   qemu-kvm qemu-system-x86_64 qemu-system-aarch64 qemu-system-i386
    qemu_kvm

    # Install QEMU(other architectures), provides:
    #   ......
    #   qemu-loongarch64 qemu-system-loongarch64
    #   qemu-riscv64 qemu-system-riscv64 qemu-riscv32  qemu-system-riscv32
    #   qemu-system-arm qemu-arm qemu-armeb qemu-system-aarch64 qemu-aarch64 qemu-aarch64_be
    #   qemu-system-xtensa qemu-xtensa qemu-system-xtensaeb qemu-xtensaeb
    #   ......
    qemu

    # Mayuri Spec
    nixos-shell
    # virt-manager-qt
    virt-viewer

    distrobox

    gnome-boxes

    spice
    spice-gtk
    spice-protocol
    win-spice

    virtio-win

    edk2
    edk2-uefi-shell

    x11docker

    virtiofsd

    dmg2img

    winboat.winboat
  ];
}
