{
  config,
  pkgs,
  nur-DataEraserC,
  ...
}:
let
  daeConfigPath = "/etc/dae/config.dae";
  subscriptionConfigPath = "/etc/dae/config.d/subscription.dae";
in
{
  services.dae = {
    enable = false;
    configFile = daeConfigPath;
    openFirewall = {
      enable = true;
      port = 12345;
    };
    assetsPath = "${nur-DataEraserC.packages.${pkgs.system}.v2ray-rules-dat}/share/v2ray-rules-dat";
  };
  system.activationScripts.installDaeConfig = ''
    install -Dm 600 ${./config.dae} ${daeConfigPath}
    install -Dm 600 ${config.age.secrets."dae-subscription.dae".path} ${subscriptionConfigPath}
  '';
  services.daed = {
    enable = false;

    openFirewall = {
      enable = true;
      port = 12345;
    };

    /*
         default options

      package = inputs.daeuniverse.packages.x86_64-linux.daed;
      configDir = "/etc/daed";
      listen = "127.0.0.1:2023";
    */
  };
}
