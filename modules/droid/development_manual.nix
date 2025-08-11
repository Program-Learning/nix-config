{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  environment.packages = with pkgs; [
    man-pages
    man-pages-posix
  ];
  # documentation.dev.enable = true;
}
