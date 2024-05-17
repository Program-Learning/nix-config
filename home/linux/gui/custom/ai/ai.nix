{
  pkgs,
  pkgs-unstable,
  nixified-ai,
  LaphaeLaicmd-linux,
  ...
}: {
  home.packages = [
    nixified-ai.packages.${pkgs.system}.invokeai-nvidia
    nixified-ai.packages.${pkgs.system}.textgen-nvidia
    LaphaeLaicmd-linux.packages.${pkgs.system}.laphaelaicmd_linux
  ];
}
