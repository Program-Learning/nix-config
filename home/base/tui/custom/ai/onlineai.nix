{
  pkgs,
  pkgs-stable,
  pkgs-latest,
  LaphaeL-aicmd,
  ...
}: {
  home.packages = [
    pkgs.tgpt
    pkgs.aichat # A ai cli interface
    # LaphaeL-aicmd.packages.${pkgs.system}.laphael_aicmd
  ];
}
