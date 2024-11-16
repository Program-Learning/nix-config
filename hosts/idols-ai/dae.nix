{
  config,
  pkgs,
  nur-DataEraserC,
  ...
}: {
  services.dae = {
    enable = true;
    configFile = config.age.secrets."dae.dae".path;
    openFirewall = {
      enable = true;
      port = 12345;
    };
    assetsPath = "${nur-DataEraserC.packages.${pkgs.system}.v2ray-rules-dat}/share/v2ray-rules-dat";
  };
  services.daed = {
    enable = true;

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
