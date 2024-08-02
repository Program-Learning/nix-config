{
  pkgs,
  pkgs-stable,
  pkgs-unstable,
  pkgs-latest,
  ...
}: {
  home.packages = with pkgs-latest; [
    pkgs-unstable.ollama # Run ai locally
    aichat # A ai cli interface
    pkgs-unstable.open-webui # ollama webui
  ];
}
