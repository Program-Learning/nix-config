{
  pkgs,
  pkgs-unstable,
  ...
}: {
  ###################################################################################
  #
  #  Virtualisation - Libvirt(QEMU/KVM) / Docker / LXD / WayDroid
  #
  ###################################################################################

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        # enables pulling using containerd, which supports restarting from a partial pull
        # https://docs.docker.com/storage/containerd/
        "features" = {"containerd-snapshotter" = true;};
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

      # Enable use of NVidia GPUs from within podman containers.
      enableNvidia = false;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    # podman containers as systemd services
    #oci-containers.backend = "podman";
    #oci-containers.containers = {
    #  container-name = {
    #    image = "container-image";
    #    autoStart = true;
    #    ports = [ "127.0.0.1:1234:1234" ];
    #  };
    #};

    waydroid.enable = true;
    lxd.enable = true;
  };
}
