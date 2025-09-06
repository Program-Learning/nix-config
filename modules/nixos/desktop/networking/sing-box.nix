{
  services.sing-box = {
    enable = true;
    settings = {
      experimental = {
        cache_file = {
          enabled = true;
        };
        clash_api = {
          external_controller = "0.0.0.0:9090";
          external_ui = "@yacd@";
        };
      };
    };
  };
}
