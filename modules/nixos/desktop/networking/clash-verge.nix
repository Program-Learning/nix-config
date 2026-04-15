{
  pkgs,
  pkgs-latest,
  pkgs-stable,
  ...
}:
{
  programs.clash-verge = {
    enable = true;
    autoStart = false;
    serviceMode = true;
    tunMode = true;
    # default value is clash-verge-rev
    package = pkgs.clash-verge-rev;
  };
}
