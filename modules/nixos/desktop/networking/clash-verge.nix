{
  pkgs,
  pkgs-latest,
  pkgs-stable,
  ...
}:
{
  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
    tunMode = true;
    # default value is clash-verge-rev
    package = pkgs-stable.clash-verge-rev;
  };
}
