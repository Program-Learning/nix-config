{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs-unstable; [
    tor-browser
    microsoft-edge
    # google-chrome
  ];
}
