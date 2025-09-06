{
  pkgs,
  pkgs-stable,
  pkgs-latest,
  ...
}:
{
  services.open-webui = {
    package = pkgs-latest.open-webui;
    enable = true;
    host = "0.0.0.0";
  };
}
