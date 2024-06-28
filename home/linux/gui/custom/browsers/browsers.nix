{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs-unstable; [
    tor-browser
    # google-chrome
  ];
}
