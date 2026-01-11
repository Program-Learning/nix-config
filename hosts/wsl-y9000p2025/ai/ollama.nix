{
  pkgs,
  ...
}:
let
in
{
  services.ollama = rec {
    enable = true;
    package = pkgs.ollama;
    user = "ollama";
    group = "ollama";
    host = "0.0.0.0";
    port = 11434;
    environmentVariables = {
      OLLAMA_ORIGINS = "*";
    };
    # maybe mount can be more stable
    home = "/var/lib/ollama";
    # home = "/mnt/wsl/btr_pool/@persistent/var/lib/ollama";
    # models = "${home}/models";
  };
}
