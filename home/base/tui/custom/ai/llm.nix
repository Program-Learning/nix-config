{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs-unstable; [
    ollama # Run ai locally
    aichat # A ai cli interface
    open-webui # ollama webui
  ];
}
