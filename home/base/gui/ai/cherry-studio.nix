{
  pkgs,
  pkgs-stable,
  pkgs-latest,
  LaphaeL-aicmd,
  ...
}:
{
  home.packages = [
    pkgs-latest.cherry-studio
  ];
}
