{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    dmenu
    #rofi
  ];

  programs = {
    rofi = {
      enable = true;
    };
  };
}
