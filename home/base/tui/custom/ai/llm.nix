{
  pkgs,
  pkgs-latest,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs-latest; [
    ollama # Run ai locally
    aichat # A ai cli interface
    pkgs-unstable.open-webui # ollama webui
  ];
}
