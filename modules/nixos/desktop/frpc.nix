{
  config,
  ...
}:
{
  modules.frp.instances = {
    aliyun2025 = {
      enable = true;
      role = "client";
      configFile = "${config.age.secrets."frp_aliyun2025.toml".path}";
    };
  };
}
