{
  pkgs,
  pkgs-latest,
  pkgs-stable,
  ...
}:
{
  services.mihomo = {
    enable = false;
    tunMode = true;
    webui = pkgs.metacubexd;
    configFile = null;
  };
}
