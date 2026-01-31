{
  pkgs,
  pkgs-latest,
  pkgs-stable,
  ...
}:
{
  programs.throne = {
    enable = false;
    tunMode.enable = true;
  };
}
