{
  pkgs,
  pkgs-latest,
  ...
}: {
  home.packages = [
    pkgs-latest.tgpt
  ];
}
