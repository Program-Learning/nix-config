{
  pkgs,
  pkgs-unstable,
  LaphaeL-aicmd,
  ...
}: {
  home.packages = [
    LaphaeL-aicmd.packages.${pkgs.system}.laphael_aicmd
  ];
}
