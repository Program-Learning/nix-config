{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages = with pkgs; [
    tor-browser
    # NOTE: microsoft-edge has been removed due to lack of maintenance in nixpkgs
    # microsoft-edge
    # google-chrome
  ];
}
