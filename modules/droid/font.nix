{
  pkgs,
  config,
  pkgs-latest,
  ...
}:
{
  # Test Required
  # cause sshd broken
  # user.shell = "${pkgs.fish}/bin/fish";
  terminal.font = "${pkgs.maple-mono.NF-CN-unhinted}/share/fonts/truetype/MapleMono-NF-CN-Regular.ttf";
}
