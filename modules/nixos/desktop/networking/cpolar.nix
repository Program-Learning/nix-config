# ===============================================================================
#
# It's designed for website development, but it can be used for remote desktop as well.
#
# How to use(Web Console: <http://localhost:9200/>):
#
# Check Service Status
#   systemctl status cpolar
# Check logs
#   journalctl -u cpolar --since "2 minutes ago"
{
  config,
  nur-DataEraserC,
  pkgs,
  ...
}:
{
  imports = [
    nur-DataEraserC.nixosModules.cpolar
  ];
  services.cpolar = {
    enable = true;
    package = nur-DataEraserC.packages.${pkgs.system}.cpolar;
    configFile = "${config.age.secrets."cpolar.yml".path}";
  };
}
