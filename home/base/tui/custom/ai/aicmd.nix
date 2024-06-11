{
  pkgs,
  pkgs-latest,
  LaphaeL-aicmd,
  ...
}: {
  home.packages = [
    LaphaeL-aicmd.packages.${pkgs.system}.laphael_aicmd
  ];
}
