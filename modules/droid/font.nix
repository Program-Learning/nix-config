{
  pkgs,
  config,
  ...
}: {
  # terminal.font = "${pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];}}/share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFont-Regular.ttf";

  # Test Required
  # cause sshd broken
  # user.shell = "${pkgs.fish}/bin/fish";
  terminal.font = "${pkgs.nerdfonts.override {fonts = ["FiraCode"];}}/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Retina.ttf";
}
