{
  pkgs,
  nixpkgs-ollama,
  ...
}: let
  pkgs-ollama = import nixpkgs-ollama {
    inherit (pkgs) system;
    # To use cuda, we need to allow the installation of non-free software
    config.allowUnfree = true;
  };
in {
  services.ollama = rec {
    enable = true;
    package = pkgs-ollama.ollama;
    acceleration = "cuda";
    user = "ollama";
    group = "ollama";
    host = "0.0.0.0";
    port = 11434;
    # maybe mount can be more stable
    home = "/var/lib/ollama";
    # home = "/mnt/wsl/btr_pool/@persistent/var/lib/ollama";
    # models = "${home}/models";
  };
}
