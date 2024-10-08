{pkgs, ...}: {
  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
  };
}
