{
  pkgs,
  pkgs-latest,
  ...
}: {
  home.packages = with pkgs-latest; [
    ollama # Run ai locally
    aichat # A ai cli interface
    open-webui # ollama webui
  ];
}
