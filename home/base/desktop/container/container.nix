{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    skopeo
    docker-compose
    podman-compose
    dive # explore docker layers
  ];

  programs = {
  };
}
