{
  pkgs,
  anyrun,
  ...
}: {
  programs.fuzzel = {
    enable = true;
    # catppuccin.enable = true;
    # flavor = "mocha";
  };
}
