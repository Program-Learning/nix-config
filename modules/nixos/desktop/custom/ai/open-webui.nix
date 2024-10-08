{
  pkgs,
  pkgs-stable,
  ...
}: {
  services.open-webui = {
    package = pkgs-stable.open-webui;
    enable = true;
    host = "0.0.0.0";
  };
}
