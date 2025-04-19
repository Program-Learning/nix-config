{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    tor-browser
    microsoft-edge
    # google-chrome
  ];
}
