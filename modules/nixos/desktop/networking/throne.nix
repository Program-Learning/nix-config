{
  pkgs,
  pkgs-latest,
  pkgs-stable,
  ...
}:
{
  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
}
