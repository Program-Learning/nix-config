{
  pkgs,
  pkgs-stable,
  pkgs-unstable,
  pkgs-latest,
  ...
}: {
  home.packages = with pkgs-stable; [
    ollama # Run ai locally
    aichat # A ai cli interface
    open-webui # ollama webui
  ];
}
