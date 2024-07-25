{
  pkgs,
  pkgs-unstable,
  nixified-ai,
  ...
}: {
  home.packages = [
    nixified-ai.packages.${pkgs.system}.invokeai-nvidia
    nixified-ai.packages.${pkgs.system}.textgen-nvidia
  ];
}
