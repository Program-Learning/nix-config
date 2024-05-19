{
  pkgs,
  pkgs-unstable,
  LaphaeLaicmd-linux,
  ...
}: {
  home.packages = [
    LaphaeLaicmd-linux.packages.${pkgs.system}.laphaelaicmd_linux
  ];
}
