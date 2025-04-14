{
  pkgs,
  pkgs-latest,
  pkgs-stable,
  ...
}: {
  services.ollama = {
    host = "0.0.0.0";
    enable = true;
    acceleration = "cuda";
  };
}
