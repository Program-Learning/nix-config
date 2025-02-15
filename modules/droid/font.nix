{
  pkgs,
  config,
  ...
}: {
  # terminal.font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFont-Regular.ttf";

  # Test Required
  # cause sshd broken
  # user.shell = "${pkgs.fish}/bin/fish";
  terminal.font = "${pkgs.nerd-fonts.fira-code}/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Retina.ttf";
}
